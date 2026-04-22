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
    println("ERRO: Faltam argumentos para o M1 (Diário/Flexível).")
    println("Uso: julia daily_flexible_allocation.jl <ABASTECIMENTO_CSV> <OUTPUT_ALOCACAO_CSV> <OUTPUT_CUSTO_CSV>")
    exit(1)
end

input_file = ARGS[1]
output_alocacao_file = ARGS[2]
output_custo_file = ARGS[3]

abastecimento = CSV.read(input_file, DataFrame, header=true)
rotas = CSV.read(paths["routes"], DataFrame)

NUM_DIAS = size(abastecimento, 2) - 1
NUM_BENEFICIARIOS = size(abastecimento, 1)
NM_TOTAL = params["total_water_sources"]
CAPACIDADE_MAX = params["max_capacity_source"]

NB_TOTAL_ROTAS = 3315 # Arquivo de rotas possui 3315 beneficiários
distancias = rotas.distance_w_factor
Dij_completa = transpose(reshape(distancias, (NB_TOTAL_ROTAS, 92)))
Dij = Dij_completa[1:NM_TOTAL, 1:NUM_BENEFICIARIOS]
Ajk = Matrix{Float64}(abastecimento[1:NUM_BENEFICIARIOS, 2:end])

df_alocacao = copy(abastecimento)

function resolvePL_diario(dia)
    NM = NM_TOTAL
    NB = NUM_BENEFICIARIOS

    linModel = Model(Gurobi.Optimizer)
    set_silent(linModel) 
    set_optimizer_attribute(linModel, "Threads", get(params, "threads", 4))
    set_optimizer_attribute(linModel, "MIPGap", get(params, "mip_gap", 0.002))

    @variable(linModel, 0 <= x[i=1:NM, j=1:NB], Int)

    # Restrição 1: Capacidade do manancial no dia
    @constraint(linModel, atendimentoManancial[i=1:NM], sum(x[i,j] for j in 1:NB) <= CAPACIDADE_MAX)
    
    # Restrição 2: Demanda do beneficiário (do plano de abastecimento)
    @constraint(linModel, atendimentoDemanda[j=1:NB], sum(x[i,j] for i in 1:NM) == Ajk[j, dia])
    
    @objective(linModel, Min, sum(sum(Dij[i,j]*x[i,j] for j in 1:NB) for i in 1:NM))

    optimize!(linModel)

    x_sol = value.(x)
    for j in 1:NB
        if Ajk[j, dia] > 0
            for i in 1:NM
                if x_sol[i,j] > 0.5
                    df_alocacao[j, dia + 1] = i
                    break
                end
            end
        else
            df_alocacao[j, dia + 1] = 0
        end
    end

    return objective_value(linModel), num_variables(linModel)
end

function roda_M1(ND_total::Int)
    df_resultados_total = DataFrame(Tempo_de_Execucao = Float64[], Solucao_otima = Float64[], Num_Variaveis = Int[])
    
    for dia in 1:ND_total
        tempo_inicio_dia = time()
        custo, vars = resolvePL_diario(dia)
        tempo_fim_dia = time()
        
        push!(df_resultados_total, (tempo_fim_dia - tempo_inicio_dia, custo, vars))
    end
  
    CSV.write(output_custo_file, df_resultados_total)
    CSV.write(output_alocacao_file, df_alocacao)
    println("Alocação flexível (diária) concluída.")
end

roda_M1(NUM_DIAS)
