import pandas as pd
import numpy as np
import time
import os
import sys
from pathlib import Path

# Load config
sys.path.append(str(Path(__file__).parent.parent.parent))
from utils.config_loader import load_config

config = load_config("config.json")
paths = config["paths"]
params = config["parameters"]

CAPACIDADE_MANANCIAL_DIA = params["max_capacity_source"]
TOTAL_BENEFICIARIOS = params["total_beneficiaries"]
TOTAL_MANANCIAIS = params["total_water_sources"]

PATH_ABASTECIMENTO = sys.argv[1] if len(sys.argv) > 1 else str(Path(paths["base_data"]) / "abastecimento_diario.csv")
PATH_ROTAS = paths["routes"]
OUTPUT_DIR = Path(paths["results"]) / "daily_flexible"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

print("--- INICIANDO HEURÍSTICA DE ALOCAÇÃO M1 (DIÁRIA/FLEXÍVEL) ---")

try:
    df_abastecimento = pd.read_csv(PATH_ABASTECIMENTO).head(TOTAL_BENEFICIARIOS)
    ids_beneficiarios = df_abastecimento.iloc[:, 0].values
    matriz_demanda = df_abastecimento.iloc[:, 1:].values.astype(float)
    num_beneficiarios, num_dias = matriz_demanda.shape
except Exception as e:
    print(f"ERRO ao ler abastecimento: {e}")
    sys.exit(1)

try:
    df_rotas = pd.read_csv(PATH_ROTAS)
    NUM_MANANCIAIS_TOTAL = 92
    matriz_custo = np.full((NUM_MANANCIAIS_TOTAL, num_beneficiarios), np.inf)
    
    col_ben = next((c for c in df_rotas.columns if 'beneficiario' in c.lower()), df_rotas.columns[0])
    col_fonte = next((c for c in df_rotas.columns if 'fonte' in c.lower()), df_rotas.columns[1])
    col_dist = next((c for c in df_rotas.columns if 'dist' in c.lower()), df_rotas.columns[2])

    for row in df_rotas.itertuples(index=False):
        b_idx = int(getattr(row, col_ben)) - 1
        f_idx = int(getattr(row, col_fonte)) - 1
        dist = float(getattr(row, col_dist))
        
        if 0 <= b_idx < num_beneficiarios and 0 <= f_idx < NUM_MANANCIAIS_TOTAL:
            matriz_custo[f_idx, b_idx] = dist
            
except Exception as e:
    print(f"ERRO CRÍTICO ao ler rotas: {e}")
    sys.exit(1)

start_time = time.time()
dados_saida = np.zeros((num_beneficiarios, num_dias), dtype=int)
custo_total = 0.0

for d in range(num_dias):
    usage_y_dia = np.zeros(NUM_MANANCIAIS_TOTAL)
    demandas_hoje = matriz_demanda[:, d]
    
    ordem_b = np.argsort(demandas_hoje)[::-1]
    
    for j in ordem_b:
        dem = demandas_hoje[j]
        if dem == 0: continue
        
        distancias = matriz_custo[:, j]
        fontes_candidatas = np.argsort(distancias)
        
        for i in fontes_candidatas:
            if i >= TOTAL_MANANCIAIS or distancias[i] == np.inf: continue
            
            if usage_y_dia[i] + dem <= CAPACIDADE_MANANCIAL_DIA:
                dados_saida[j, d] = i + 1 # 1-based index
                usage_y_dia[i] += dem
                custo_total += distancias[i] * dem
                break

df_output = pd.DataFrame(columns=['Beneficiarios'] + list(df_abastecimento.columns[1:]))
df_output['Beneficiarios'] = ids_beneficiarios
df_output.iloc[:, 1:] = dados_saida
df_output.to_csv(OUTPUT_DIR / "alocacao_heuristica_diaria.csv", index=False)

print(f"Concluído. Tempo: {time.time() - start_time:.2f}s | Custo Est.: {custo_total:.2f}")
