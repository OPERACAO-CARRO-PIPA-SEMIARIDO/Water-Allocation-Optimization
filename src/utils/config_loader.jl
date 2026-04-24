using JSON

function load_config(local_config_name="config.json")
    # Project root is assumed to be 2 levels up from src/utils/config_loader.jl
    utils_dir = dirname(abspath(@__FILE__))
    project_root = dirname(dirname(utils_dir))
    global_config_path = joinpath(project_root, "config.json")
    
    config = Dict("paths" => Dict(), "parameters" => Dict())

    # Load global config
    if isfile(global_config_path)
        global_config = JSON.parsefile(global_config_path)
        if haskey(global_config, "paths")
            for (k, v) in global_config["paths"]
                config["paths"][k] = abspath(joinpath(project_root, v))
            end
        end
        if haskey(global_config, "parameters")
            merge!(config["parameters"], global_config["parameters"])
        end
    end

    # Load local config
    current_dir = pwd()
    local_found = false
    for _ in 1:3
        possible_path = joinpath(current_dir, local_config_name)
        if isfile(possible_path) && abspath(possible_path) != abspath(global_config_path)
            local_config = JSON.parsefile(possible_path)
            if haskey(local_config, "paths")
                for (k, v) in local_config["paths"]
                    if isabspath(v)
                        config["paths"][k] = v
                    else
                        config["paths"][k] = abspath(joinpath(project_root, v))
                    end
                end
            end
            if haskey(local_config, "parameters")
                merge!(config["parameters"], local_config["parameters"])
            end
            local_found = true
            break
        end
        current_dir = dirname(current_dir)
    end

    if !local_found && !isfile(global_config_path)
        error("Neither global config nor local config $local_config_name found.")
    end

    return config
end
