using JuMP
using LinearAlgebra
using CSV
using DataFrames
using Gurobi

# Carrega configurações locais
include("../../utils/config_loader.jl")
config = load_config("config.json")
paths = config["paths"]
params = config["parameters"]

if length(ARGS) < 3
    println("ERRO: Faltam argumentos para o M2 (Anual/Fixo).")
    println("Uso: julia annual_fixed_allocation.jl <ABASTECIMENTO_CSV> <OUTPUT_ALOCACAO_CSV> <OUTPUT_CUSTO_CSV>")
    exit(1)
end

ABASTECIMENTO_FILE = ARGS[1]
OUTPUT_ALOCACAO = ARGS[2]
OUTPUT_CUSTO = ARGS[3]

abastecimento = CSV.read(ABASTECIMENTO_FILE, DataFrame, header=true)
rotas = CSV.read(paths["routes"], DataFrame)

NUM_DIAS = size(abastecimento, 2) - 1
NUM_BENEFICIARIOS = size(abastecimento, 1)
NM_TOTAL = params["total_water_sources"]
CAPACIDADE_MAX = params["max_capacity_source"]

NB_TOTAL_ROTAS = get(params, "total_beneficiaries_in_file", 3315)
NM_TOTAL_ROTAS = get(params, "total_water_sources_in_file", 92)
distancias = rotas.distance_w_factor
Dij_completa = transpose(reshape(distancias, (NB_TOTAL_ROTAS, NM_TOTAL_ROTAS)))
Dij = Dij_completa[1:NM_TOTAL, 1:NUM_BENEFICIARIOS]
Ajk = Matrix{Float64}(abastecimento[:, 2:end])

function resolve_M2_anual(NM, NB, ND, matriz_dist, matriz_demanda, cap_max)
    env = Gurobi.Env()
    linModel = Model(() -> Gurobi.Optimizer(env))
    set_silent(linModel) 
    set_time_limit_sec(linModel, 86400.0)
    set_optimizer_attribute(linModel, "Threads", get(params, "threads", 4))
    set_optimizer_attribute(linModel, "MIPGap", get(params, "mip_gap", 0.002))

    @variable(linModel, 0 <= x[i=1:NM, j=1:NB, k=1:ND; matriz_demanda[j,k] > 0], Int) 
    @variable(linModel, y[i=1:NM, j=1:NB], Bin)              

    @constraint(linModel, cap_diaria[i=1:NM, k=1:ND], sum(x[i,j,k] for j in 1:NB if matriz_demanda[j,k] > 0) <= cap_max)
    @constraint(linModel, atende_dem[j=1:NB, k=1:ND; matriz_demanda[j,k] > 0], sum(x[i,j,k] for i in 1:NM) == matriz_demanda[j,k])
    
    # Restrição Central M2: Fonte Única por Beneficiário
    @constraint(linModel, fonte_unica[j=1:NB], sum(y[i,j] for i in 1:NM) == 1)
    
    @constraint(linModel, amarra_x_y[i=1:NM, j=1:NB, k=1:ND; matriz_demanda[j,k] > 0], x[i,j,k] <= matriz_demanda[j,k] * y[i,j])

    @objective(linModel, Min, sum(matriz_dist[i,j] * x[i,j,k] for i in 1:NM, j in 1:NB, k in 1:ND if matriz_demanda[j,k] > 0))

    tempo_inicio = time()
    optimize!(linModel)
    tempo_exec = time() - tempo_inicio

    if has_values(linModel)
        return value.(y), objective_value(linModel), num_variables(linModel), tempo_exec, true
    else
        return zeros(Int, NM, NB), 0.0, num_variables(linModel), tempo_exec, false
    end
end

y_opt, custo_total, num_vars, tempo_exec, solucao_valida = resolve_M2_anual(NM_TOTAL, NUM_BENEFICIARIOS, NUM_DIAS, Dij, Ajk, CAPACIDADE_MAX)

if solucao_valida
    df_alocacao = copy(abastecimento)

    for j in 1:NUM_BENEFICIARIOS
        fonte_escolhida = 0
        for i in 1:NM_TOTAL
            if y_opt[i,j] > 0.5
                fonte_escolhida = i
                break
            end
        end
        
        for k in 1:NUM_DIAS
            if Ajk[j, k] > 0
                df_alocacao[j, k + 1] = fonte_escolhida
            else
                df_alocacao[j, k + 1] = 0
            end
        end
    end

    df_metricas = DataFrame(Tempo_de_Execucao = [tempo_exec], Solucao_otima = [custo_total], Num_Variaveis = [num_vars])

    CSV.write(OUTPUT_CUSTO, df_metricas)
    CSV.write(OUTPUT_ALOCACAO, df_alocacao)
    println("Alocação fixa (anual) concluída com sucesso.")
else
    println("Falha na alocação M2.")
    exit(1)
end
