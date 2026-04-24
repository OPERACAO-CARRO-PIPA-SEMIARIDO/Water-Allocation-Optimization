import json
import os
from pathlib import Path

def load_config(local_config_path="config.json"):
    """
    Loads a global config.json from the project root and merges it with a 
    local config.json. Local parameters override global ones.
    """
    # Find project root (assumed to be 2 levels up from src/utils)
    utils_dir = Path(os.path.dirname(os.path.abspath(__file__)))
    project_root = utils_dir.parent.parent
    
    global_config_path = project_root / "config.json"
    config = {"paths": {}, "parameters": {}}

    # Load global config
    if global_config_path.exists():
        with open(global_config_path, 'r', encoding='utf-8') as f:
            global_config = json.load(f)
            for k, v in global_config.get("paths", {}).items():
                # Make paths absolute relative to project root
                config["paths"][k] = str(project_root / v)
            config["parameters"].update(global_config.get("parameters", {}))

    # Load local config
    search_dir = Path.cwd()
    local_found = False
    for _ in range(3):
        possible_path = search_dir / local_config_path
        if possible_path.exists() and possible_path.resolve() != global_config_path.resolve():
            with open(possible_path, 'r', encoding='utf-8') as f:
                local_config = json.load(f)
                if "paths" in local_config:
                    for k, v in local_config["paths"].items():
                        # If local path is relative, make it absolute from project root
                        # or keep it if it's already absolute
                        p = Path(v)
                        if not p.is_absolute():
                            config["paths"][k] = str(project_root / v)
                        else:
                            config["paths"][k] = v
                if "parameters" in local_config:
                    config["parameters"].update(local_config["parameters"])
                local_found = True
            break
        search_dir = search_dir.parent

    if not local_found and not global_config_path.exists():
         raise FileNotFoundError(f"Neither global config nor local config {local_config_path} found.")

    return config
