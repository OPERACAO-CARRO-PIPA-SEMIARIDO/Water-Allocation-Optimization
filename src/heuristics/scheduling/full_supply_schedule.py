import pandas as pd
import numpy as np
import time
import sys
from pathlib import Path

sys.path.append(str(Path(__file__).parent.parent.parent))
from utils.config_loader import load_config

config = load_config("config.json")
paths = config["paths"]
params = config["parameters"]

CAPACIDADE_CAMINHAO = params["truck_capacity"]
NUM_DIAS = params["total_days"]
TOTAL_BENEFICIARIOS = params["total_beneficiaries"]

print("--- Iniciando Heurística: Full Supply Schedule ---")

try:
    beneficiarios_total = pd.read_csv(paths["beneficiaries"]).head(TOTAL_BENEFICIARIOS)
    dias_uteis_df = pd.read_csv(paths["dates"]).head(NUM_DIAS)
except FileNotFoundError as e:
    print(f"Erro Crítico: {e}")
    exit()

consumo_diario_vals = (beneficiarios_total['Pessoas_Atendidas'] * 0.02).round(2).values
capacidade_cisterna_vals = beneficiarios_total['Capacidade'].astype(float).values

coluna_flag = dias_uteis_df.columns[0]
dia_nao_util = set(dias_uteis_df[dias_uteis_df[coluna_flag] == 0].index)

df_volume = pd.DataFrame(0.0, index=beneficiarios_total.index, columns=range(NUM_DIAS))
df_entregas = pd.DataFrame(0, index=beneficiarios_total.index, columns=range(NUM_DIAS))

df_volume.iloc[:, 0] = capacidade_cisterna_vals

start_time = time.time()

for i in range(1, NUM_DIAS):
    entregas_hoje = np.zeros(len(beneficiarios_total))
    volume_atual = df_volume.iloc[:, i-1].values - consumo_diario_vals
    
    if i in dia_nao_util:
        df_volume.iloc[:, i] = np.where(volume_atual < 0, 0.0, volume_atual)
    else: 
        espaco_livre = capacidade_cisterna_vals - volume_atual
        numero_caminhoes = espaco_livre // CAPACIDADE_CAMINHAO
        
        cond1 = numero_caminhoes > 0
        volume_atual = np.where(cond1, volume_atual + CAPACIDADE_CAMINHAO * numero_caminhoes, volume_atual)
        entregas_hoje += np.where(cond1, numero_caminhoes, 0.0)

        cond2 = volume_atual <= consumo_diario_vals
        volume_atual = np.where(cond2, volume_atual + CAPACIDADE_CAMINHAO, volume_atual)
        entregas_hoje += np.where(cond2, 1.0, 0.0)

        nao_uteis_consecutivos = 0
        while i + nao_uteis_consecutivos + 1 < NUM_DIAS and (i + nao_uteis_consecutivos + 1) in dia_nao_util:
             nao_uteis_consecutivos += 1

        if nao_uteis_consecutivos > 0:
            ajuste_volume = consumo_diario_vals * nao_uteis_consecutivos
            cond3 = (volume_atual - ajuste_volume <= 0)
            volume_atual = np.where(cond3, volume_atual + CAPACIDADE_CAMINHAO, volume_atual)
            entregas_hoje += np.where(cond3, 1.0, 0.0)

        volume_final = np.where(volume_atual > capacidade_cisterna_vals, capacidade_cisterna_vals, volume_atual)
        volume_final = np.where(volume_final < 0, 0.0, volume_final)
        df_volume.iloc[:, i] = volume_final
    
    df_entregas.iloc[:, i] = entregas_hoje

df_volume.columns = range(1, NUM_DIAS + 1)
df_entregas.columns = range(1, NUM_DIAS + 1)
df_volume.insert(0, 'Beneficiarios', beneficiarios_total.index + 1)
df_entregas.insert(0, 'Beneficiarios', beneficiarios_total.index + 1)

output_dir = Path(paths["results"]) / "full_supply"
output_dir.mkdir(parents=True, exist_ok=True)

df_volume.to_csv(output_dir / "volumes_diarios.csv", index=False)
df_entregas.to_csv(output_dir / "abastecimento_diario.csv", index=False)
print(f"Resultados salvos em {output_dir}")
