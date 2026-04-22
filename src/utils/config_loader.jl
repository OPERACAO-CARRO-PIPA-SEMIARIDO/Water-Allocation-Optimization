using JSON

function load_config(config_name="config.json")
    # Searches for config.json in current directory or parent directories
    current_dir = pwd()
    for _ in 1:3
        possible_path = joinpath(current_dir, config_name)
        if isfile(possible_path)
            return JSON.parsefile(possible_path)
        end
        current_dir = dirname(current_dir)
    end
    error("Config file $config_name not found.")
end
