using JuMP
using LinearAlgebra
using CSV
using DataFrames
using Gurobi
using Base.Threads

include("../../utils/config_loader.jl")
config = load_config("config.json")
paths = config["paths"]
params = config["parameters"]

beneficiarios_ativos = CSV.read(paths["beneficiaries"], DataFrame)
dias_uteis = CSV.read(paths["dates"], DataFrame)
calendarios = CSV.read(paths["calendars"], DataFrame)

calendarioCarnaval = calendarios.carnaval
entregasObrigatorias = calendarios.lil

nb = 1:params["total_beneficiaries"]
nd = 1:params["total_days"]

qtd_dias_uteis = sum(dias_uteis[nd, 1]) 

preU = [round(i * 0.02, digits=2) for i in beneficiarios_ativos.Pessoas_Atendidas]
preC = convert(Vector{Float64}, beneficiarios_ativos.Capacidade)
U = [preU[j] for j in nb]
C = [preC[j] for j in nb]

Y = C ./ U
quebra4 = [beneficiario for (beneficiario, x) in zip(nb, Y) if x < 5]
quebra3 = [beneficiario for (beneficiario, x) in zip(nb, Y) if x < 4]
quebra2 = [beneficiario for (beneficiario, x) in zip(nb, Y) if x < 3]

function rodar_cenario(p_valor, nome_pasta; arquivo_warm_start=nothing)
    caminho_pasta = joinpath(paths["results"], nome_pasta)
    mkpath(caminho_pasta)

    model = Model(Gurobi.Optimizer)
    
    set_optimizer_attribute(model, "NodefileStart", 20.0)
    set_optimizer_attribute(model, "MIPFocus", 1) 
    set_optimizer_attribute(model, "MIPGap", get(params, "mip_gap", 0.002))
    set_optimizer_attribute(model, "Threads", get(params, "threads", 4))

    @variable(model, 0 <= x[j in nb, k in nd], Int)
    @variable(model, 0 <= V[j in nb, k in nd])
    @variable(model, 0 <= y, Int)

    @objective(model, Min, p_valor * qtd_dias_uteis * y + (1 - p_valor) * sum(x[j, k] for j in nb, k in nd))

    @constraint(model, balancoVolumeInicial[j in nb], V[j, 1] == C[j])
    @constraint(model, balancoVolume[j in nb, k in 2:last(nd);
            !(calendarioCarnaval[k] == -1 && j in quebra4) &&
            !(entregasObrigatorias[k] == -1 && j in quebra2)],
        V[j, k] <= V[j, k-1] - U[j] + 13.0 * x[j, k])
    @constraint(model, correcaoVolume[j in nb, k in nd;
            (calendarioCarnaval[k] == -1 && j in quebra4) ||
            (entregasObrigatorias[k] == -1 && j in quebra2)],
        V[j, k] == 0)
    @constraint(model, diasInuteis[j in nb, k in nd; Int(dias_uteis[k, 1]) == 0], x[j, k] == 0)
    @constraint(model, maiorPico[k in nd], sum(x[j, k] for j in nb) <= y)
    @constraint(model, volumeMinimo[j in nb, k in nd], V[j, k] >= 0)
    @constraint(model, capacidadeMax[j in nb, k in nd], V[j, k] <= C[j])
    @constraint(model, carnavalAbastecimento[j in quebra4, k in nd; calendarioCarnaval[k] == 1], x[j, k] >= 1)
    @constraint(model, lilAbastecimento[j in quebra2, k in nd; entregasObrigatorias[k] == 1], x[j, k] >= 1)

    if !isnothing(arquivo_warm_start) && isfile(arquivo_warm_start)
        println(">>> Carregando Warm Start de: $arquivo_warm_start")
        try
            df_start = CSV.read(arquivo_warm_start, DataFrame)
            for row in eachrow(df_start)
                j_id = hasproperty(df_start, :Beneficiarios) ? row.Beneficiarios : row[1]
                if !(j_id in nb) continue end
                for k in nd
                    col_sym = Symbol(string(k)) 
                    if hasproperty(row, col_sym)
                        valor = row[col_sym]
                        if !ismissing(valor)
                            set_start_value(x[j_id, k], valor)
                        end
                    end
                end
            end
        catch e
            println("!!! Erro ao carregar Warm Start: $e")
        end
    end

    horas_checkpoints = get(params, "time_checkpoints_hours", [3, 6, 9, 12, 15, 18, 21, 24])
    checkpoints_segundos = Float64.(horas_checkpoints .* 3600)
    nomes_arquivos = ["$(h)h" for h in horas_checkpoints]
    
    tempo_acumulado_anterior = 0.0

    for (meta_tempo_total, sufixo) in zip(checkpoints_segundos, nomes_arquivos)
        tempo_para_rodar = meta_tempo_total - tempo_acumulado_anterior
        if tempo_para_rodar <= 1.0 continue end

        set_optimizer_attribute(model, "TimeLimit", tempo_para_rodar)
        optimize!(model)
        tempo_acumulado_anterior = meta_tempo_total

        if has_values(model)
            salvar_arquivos(model, caminho_pasta, sufixo, nb, nd)
            salvar_arquivos(model, caminho_pasta, "melhor_absoluto", nb, nd)
        end

        if termination_status(model) == MOI.OPTIMAL
            println("Solução ÓTIMA comprovada!")
            break
        end
    end
end

function salvar_arquivos(model_inst, pasta, sufixo, nb_range, nd_range)
    val_x = value.(model_inst[:x])
    colunas_x = Any[[j for j in nb_range]]
    for i in nd_range
        push!(colunas_x, [round(Int, val_x[j, i]) for j in nb_range])
    end
    df_x = DataFrame(colunas_x, Symbol.(["Beneficiarios"; nd_range...]))
    CSV.write(joinpath(pasta, "abastecimento_$sufixo.csv"), df_x)
end

if length(ARGS) >= 2
    p_valor = parse(Float64, ARGS[1])
    nome_pasta = ARGS[2]
    ws_file = length(ARGS) >= 3 ? ARGS[3] : nothing
    rodar_cenario(p_valor, nome_pasta, arquivo_warm_start=ws_file)
else
    p_def = get(params, "p_value", 0.1)
    println("Usando valor p padrão: $p_def")
    ws_file_def = get(params, "use_warm_start", false) ? get(paths, "warm_start_file", nothing) : nothing
    if ws_file_def == "" ws_file_def = nothing end
    rodar_cenario(p_def, "resultado_picos", arquivo_warm_start=ws_file_def)
end
