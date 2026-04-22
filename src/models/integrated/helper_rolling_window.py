import os
import subprocess
import pandas as pd
from pathlib import Path
import sys

# Load local config
sys.path.append(str(Path(__file__).parent.parent.parent))
from utils.config_loader import load_config

config = load_config("config.json")
params = config["parameters"]
paths = config["paths"]

JULIA_SCRIPT = "integrated_rolling_window.jl"
TOTAL_DIAS = params["total_days"]
WINDOW_SIZE = 60
OVERLAP = 14
PESO_PICO = params.get("p_value", 0.1)
K_CANDIDATOS = params["num_candidates"]

def executar_rolling_window():
    script_path = Path(__file__).parent / JULIA_SCRIPT
    output_base_name = f"rolling_window_{WINDOW_SIZE}_{OVERLAP}_{K_CANDIDATOS}"
    output_dir = Path(paths["results"]) / output_base_name
    output_dir.mkdir(parents=True, exist_ok=True)

    initial_volumes_config = paths.get("initial_volumes_file", "")
    volumes_iniciais_path = initial_volumes_config if initial_volumes_config != "" else "nothing"
    
    pasta_anterior = "nothing"
    dia_inicio = 1
    periodo_count = 1

    while dia_inicio <= TOTAL_DIAS:
        num_dias = min(WINDOW_SIZE, TOTAL_DIAS - dia_inicio + 1)
        pasta_periodo = output_dir / f"periodo_{periodo_count}_dia_{dia_inicio}"
        pasta_periodo.mkdir(exist_ok=True)

        print(f"\n>>> Executando Rolling Window Período {periodo_count}: Dias {dia_inicio} a {dia_inicio + num_dias - 1}")

        cmd = [
            "julia", str(script_path),
            str(PESO_PICO),
            str(pasta_periodo),
            str(dia_inicio),
            str(num_dias),
            str(volumes_iniciais_path),
            str(pasta_anterior if USE_WARM_START else "nothing"),
            str(OVERLAP if (periodo_count > 1 and USE_WARM_START) else 0),
            str(K_CANDIDATOS)
        ]

        try:
            subprocess.run(cmd, check=True)
            volumes_todos = pasta_periodo / "volumes_todos_dias.csv"
            if not volumes_todos.exists():
                break

            if dia_inicio + num_dias - 1 >= TOTAL_DIAS:
                break

            proximo_dia_inicio = dia_inicio + (WINDOW_SIZE - OVERLAP)
            dia_global_ref = proximo_dia_inicio - 1
            dia_local_ref = dia_global_ref - dia_inicio + 1

            df_vol = pd.read_csv(volumes_todos)
            col_name = str(dia_local_ref)

            if col_name in df_vol.columns:
                next_vol_init = pasta_periodo / f"volumes_para_dia_{proximo_dia_inicio}.csv"
                df_next = df_vol[["Beneficiarios", col_name]].copy()
                df_next.columns = ["Beneficiario", "Volume"]
                df_next.to_csv(next_vol_init, index=False)
                volumes_iniciais_path = next_vol_init
            else:
                volumes_iniciais_path = pasta_periodo / "volumes_finais.csv"

            pasta_anterior = pasta_periodo
            dia_inicio = proximo_dia_inicio
            periodo_count += 1
        except subprocess.CalledProcessError as e:
            print(f"    ERRO ao executar Julia: {e}")
            break

    print("Rolling Window Completo.")

if __name__ == "__main__":
    executar_rolling_window()
__ == "__main__":
    executar_rolling_window()
