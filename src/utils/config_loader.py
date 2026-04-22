import json
import os
from pathlib import Path

def load_config(config_path="config.json"):
    """
    Loads the local config.json from the caller's directory.
    If not found, searches upwards up to 2 directories.
    """
    current_dir = Path(os.path.dirname(os.path.abspath(__file__)))
    target_path = Path(config_path)

    # First try: exact path if absolute
    if target_path.is_absolute() and target_path.exists():
        with open(target_path, 'r', encoding='utf-8') as f:
            return json.load(f)

    # Second try: caller's directory or upwards
    search_dir = Path.cwd()
    for _ in range(3):
        possible_path = search_dir / config_path
        if possible_path.exists():
            with open(possible_path, 'r', encoding='utf-8') as f:
                return json.load(f)
        search_dir = search_dir.parent

    raise FileNotFoundError(f"Config file {config_path} not found.")
