using JuMP
using LinearAlgebra
using CSV
using DataFrames
using Gurobi
using MathOptInterface
const MOI = MathOptInterface

include("../../utils/config_loader.jl")
config = load_config("config.json")
params = config["parameters"]
paths = config["paths"]

const TOTAL_MANANCIAIS_ARQUIVO = get(params, "total_water_sources_in_file", 92)
const NB_TOTAL_ROTAS = get(params, "total_beneficiaries_in_file", 3315)
const CAPACIDADE_MAX_MANANCIAL = params["max_capacity_source"]
const CAPACIDADE_CAMINHAO = get(params, "truck_capacity", 13.0)

function rodar_rolling_window(
    p::Float64, 
    nome_pasta::String, 
    dia_inicio::Int, 
    num_dias_periodo::Int;
    caminho_volumes_iniciais=nothing,
    pasta_anterior=nothing,
    overlap_dias=0,
    num_candidatos=params["num_candidates"]
)
    caminho_pasta = joinpath(paths["results"], nome_pasta)
    mkpath(caminho_pasta)

    beneficiarios_ativos = CSV.read(paths["beneficiaries"], DataFrame)
    dias_uteis_full = CSV.read(paths["dates"], DataFrame)
    calendarios_full = CSV.read(paths["calendars"], DataFrame)
    rotas = CSV.read(paths["routes"], DataFrame)

    TOTAL_BENEFICIARIOS = params["total_beneficiaries"]
    TOTAL_MANANCIAIS = params["total_water_sources"]
    
    CANDIDATOS_REAIS = min(num_candidatos, TOTAL_MANANCIAIS)

    dia_fim = dia_inicio + num_dias_periodo - 1
    nd_global = dia_inicio:dia_fim
    nd_local = 1:num_dias_periodo

    calendarioCarnaval = calendarios_full.carnaval[nd_global]
    entregasObrigatorias = calendarios_full.lil[nd_global]
    dias_uteis = dias_uteis_full[nd_global, 1]

    nb = 1:TOTAL_BENEFICIARIOS
    nm = 1:TOTAL_MANANCIAIS

    qtd_dias_uteis = sum(dias_uteis) 
    preU_full = [round(i * 0.02, digits=2) for i in beneficiarios_ativos.Pessoas_Atendidas]
    U = preU_full[nb] 
    C = convert(Vector{Float64}, beneficiarios_ativos.Capacidade)[nb]

    Y = C ./ U
    quebra4 = [j for (j, x) in zip(nb, Y) if x < 5]
    quebra3 = [j for (j, x) in zip(nb, Y) if x < 4]
    quebra2 = [j for (j, x) in zip(nb, Y) if x < 3]

    distancias = rotas.distance_w_factor
    Dij_completa = transpose(reshape(distancias, (3315, TOTAL_MANANCIAIS_ARQUIVO)))
    Dij = Dij_completa[nm, nb]

    candidatos_por_beneficiario = Dict{Int, Vector{Int}}()
    for j in nb
        fontes_ordenadas = sortperm(Dij[:, j])
        candidatos_por_beneficiario[j] = fontes_ordenadas[1:CANDIDATOS_REAIS]
    end

    model = Model(Gurobi.Optimizer)
    
    set_optimizer_attribute(model, "NodefileStart", 10.0) 
    set_optimizer_attribute(model, "Threads", get(params, "threads", 4))
    set_optimizer_attribute(model, "MIPGap", get(params, "mip_gap", 0.002))

    @variable(model, 0 <= x[j in nb, i in candidatos_por_beneficiario[j], k in nd_local], Int) 
    @variable(model, z[j in nb, i in candidatos_por_beneficiario[j]], Bin) 
    @variable(model, 0 <= y_pico, Int)
    @variable(model, 0 <= V[j in nb, k in 0:num_dias_periodo])

    @expression(model, expr_pico, qtd_dias_uteis * y_pico)
    @expression(model, expr_custo, sum(Dij[i,j] * x[j, i, k] for j in nb, i in candidatos_por_beneficiario[j], k in nd_local))

    @objective(model, Min, (p * expr_pico) + ((1 - p) * expr_custo))

    if isnothing(caminho_volumes_iniciais) || !isfile(caminho_volumes_iniciais)
        @constraint(model, balancoVolumeInicial[j in nb], V[j, 0] == C[j])
    else
        df_vol_init = CSV.read(caminho_volumes_iniciais, DataFrame)
        vol_dict = Dict(row[1] => row[2] for row in eachrow(df_vol_init))
        @constraint(model, balancoVolumeInicial[j in nb], V[j, 0] == get(vol_dict, j, C[j]))
    end
    
    @constraint(model, balancoVolume[j in nb, k in 1:num_dias_periodo; !(calendarioCarnaval[k] == -1 && j in quebra4) && !(entregasObrigatorias[k] == -1 && j in quebra2)],
        V[j, k] <= V[j, k-1] - U[j] + CAPACIDADE_CAMINHAO * sum(x[j, i, k] for i in candidatos_por_beneficiario[j]))
    
    @constraint(model, correcaoVolume[j in nb, k in 1:num_dias_periodo; (calendarioCarnaval[k] == -1 && j in quebra4) || (entregasObrigatorias[k] == -1 && j in quebra2)],
        V[j, k] == 0)
        
    @constraint(model, diasInuteis[j in nb, k in nd_local; Int(dias_uteis[k]) == 0], sum(x[j, i, k] for i in candidatos_por_beneficiario[j]) == 0)
    
    @constraint(model, restMaiorPico[k in nd_local], sum(x[j, i, k] for j in nb, i in candidatos_por_beneficiario[j]) <= y_pico)
    @constraint(model, volumeMinimo[j in nb, k in 0:num_dias_periodo], V[j, k] >= 0)
    @constraint(model, capacidadeMax[j in nb, k in 0:num_dias_periodo], V[j, k] <= C[j])
    
    @constraint(model, carnavalAbastecimento[j in quebra4, k in nd_local; calendarioCarnaval[k] == 1], sum(x[j, i, k] for i in candidatos_por_beneficiario[j]) >= 1)
    @constraint(model, lilAbastecimento[j in quebra2, k in nd_local; entregasObrigatorias[k] == 1], sum(x[j, i, k] for i in candidatos_por_beneficiario[j]) >= 1)

    @constraint(model, fonteUnica[j in nb], sum(z[j, i] for i in candidatos_por_beneficiario[j]) == 1)
    @constraint(model, amarra_z_x[j in nb, k in nd_local, i in candidatos_por_beneficiario[j]], x[j, i, k] <= CAPACIDADE_MAX_MANANCIAL * z[j, i])
    @constraint(model, capDiariaManancial[i in nm, k in nd_local; !isempty([j for j in nb if i in candidatos_por_beneficiario[j]])],
        sum(x[j, i, k] for j in nb if i in candidatos_por_beneficiario[j]) <= CAPACIDADE_MAX_MANANCIAL)

    # Warm Start para o overlap
    if !isnothing(pasta_anterior) && isdir(pasta_anterior) && overlap_dias > 0
        try
            df_aloc = CSV.read(joinpath(pasta_anterior, "alocacao_melhor_absoluto.csv"), DataFrame)
            df_abast = CSV.read(joinpath(pasta_anterior, "abastecimento_melhor_absoluto.csv"), DataFrame)
            
            for j in nb
                fonte_escolhida = 0
                for col in names(df_aloc)
                    if col == "Beneficiarios" continue end
                    val_fonte = df_aloc[j, col]
                    if val_fonte > 0
                        fonte_escolhida = Int(val_fonte)
                        break
                    end
                end

                if fonte_escolhida > 0 && fonte_escolhida in candidatos_por_beneficiario[j]
                    set_start_value(z[j, fonte_escolhida], 1.0)
                    for i in candidatos_por_beneficiario[j]
                        if i != fonte_escolhida set_start_value(z[j, i], 0.0) end
                    end
                end
            end

            num_dias_anterior = size(df_abast, 2) - 1
            for od in 1:overlap_dias
                col_idx = num_dias_anterior - overlap_dias + od
                col_name = string(col_idx)
                if hasproperty(df_abast, Symbol(col_name))
                    for j in nb
                        qtd = df_abast[j, col_name]
                        fonte = df_aloc[j, col_name]
                        if fonte > 0 && fonte in candidatos_por_beneficiario[j]
                            set_start_value(x[j, fonte, od], Float64(qtd))
                        end
                    end
                end
            end
        catch e
            println("AVISO: Falha ao carregar Warm Start: $e")
        end
    end

    horas_checkpoints = get(params, "time_checkpoints_hours", [3, 6, 9, 12, 15, 18, 21, 24])
    melhor_obj_encontrado = Inf
    tempo_inicio_global = time()

    for meta_hora in horas_checkpoints
        tempo_real_passado = time() - tempo_inicio_global
        tempo_restante = (meta_hora * 3600.0) - tempo_real_passado
        if tempo_restante <= 0 continue end

        set_optimizer_attribute(model, "TimeLimit", tempo_restante)
        optimize!(model)

        if has_values(model)
            obj = objective_value(model)
            if obj < melhor_obj_encontrado
                melhor_obj_encontrado = obj
                salvar_saidas_sliding(model, caminho_pasta, "melhor_absoluto", nb, nd_local, candidatos_por_beneficiario)
                salvar_volumes_finais_sliding(model, caminho_pasta, "volumes_finais", nb, nd_local)
            end
        end

        if termination_status(model) == MOI.OPTIMAL break end
    end
end

function salvar_saidas_sliding(model, pasta, sufixo, nb, nd_local, candidatos_por_beneficiario)
    val_x = value.(model[:x])
    val_z = value.(model[:z])
    colunas_abastecimento = Any[[j for j in nb]]
    colunas_alocacao = Any[[j for j in nb]]
    for k in nd_local
        arr_abast_dia = Int[]
        arr_aloc_dia = Int[]
        for j in nb
            fonte_escolhida = 0
            for i in candidatos_por_beneficiario[j]
                if val_z[j, i] > 0.5
                    fonte_escolhida = i
                    break
                end
            end
            soma_caminhoes = sum(round(Int, val_x[j, i, k]) for i in candidatos_por_beneficiario[j])
            push!(arr_abast_dia, soma_caminhoes)
            push!(arr_aloc_dia, soma_caminhoes > 0 ? fonte_escolhida : 0)
        end
        push!(colunas_abastecimento, arr_abast_dia)
        push!(colunas_alocacao, arr_aloc_dia)
    end
    CSV.write(joinpath(pasta, "abastecimento_$sufixo.csv"), DataFrame(colunas_abastecimento, Symbol.(["Beneficiarios"; nd_local...])))
    CSV.write(joinpath(pasta, "alocacao_$sufixo.csv"), DataFrame(colunas_alocacao, Symbol.(["Beneficiarios"; nd_local...])))
end

function salvar_volumes_finais_sliding(model, pasta, sufixo, nb, nd_local)
    val_V = value.(model[:V])
    ultimo_dia = last(nd_local)
    df_finais = DataFrame(Beneficiario = Int[], Volume = Float64[])
    for j in nb
        push!(df_finais, (j, val_V[j, ultimo_dia]))
    end
    CSV.write(joinpath(pasta, "$sufixo.csv"), df_finais)

    colunas_volumes = Any[[j for j in nb]]
    for k in [0; collect(nd_local)]
        push!(colunas_volumes, [val_V[j, k] for j in nb])
    end
    df_todos = DataFrame(colunas_volumes, Symbol.(["Beneficiarios"; 0; nd_local...]))
    CSV.write(joinpath(pasta, "volumes_todos_dias.csv"), df_todos)
end

if length(ARGS) >= 4
    p = parse(Float64, ARGS[1])
    pasta = ARGS[2]
    dia_ini = parse(Int, ARGS[3])
    num_d = parse(Int, ARGS[4])
    vol_init = length(ARGS) >= 5 ? (ARGS[5] == "nothing" ? nothing : ARGS[5]) : nothing
    pasta_ant = length(ARGS) >= 6 ? (ARGS[6] == "nothing" ? nothing : ARGS[6]) : nothing
    overlap = length(ARGS) >= 7 ? parse(Int, ARGS[7]) : 0
    k_candidatos = length(ARGS) >= 8 ? parse(Int, ARGS[8]) : 1
    
    rodar_rolling_window(p, pasta, dia_ini, num_d, caminho_volumes_iniciais=vol_init, pasta_anterior=pasta_ant, overlap_dias=overlap, num_candidatos=k_candidatos)
end
