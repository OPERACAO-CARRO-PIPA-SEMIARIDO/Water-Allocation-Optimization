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

print("--- Iniciando Heurística: Limited Supply Schedule ---")

try:
    beneficiarios_total = pd.read_csv(paths["beneficiaries"]).head(TOTAL_BENEFICIARIOS)
    dias_uteis_df = pd.read_csv(paths["dates"]).head(NUM_DIAS)
except FileNotFoundError as e:
    print(f"Erro Crítico: {e}")
    exit()

consumo_diario = (beneficiarios_total['Pessoas_Atendidas'] * 0.02).round(2).values
capacidade_cisterna = beneficiarios_total['Capacidade'].values.astype(float)

coluna_flag_dia = dias_uteis_df.columns[0] 
indices_dias_nao_uteis = set(dias_uteis_df[dias_uteis_df[coluna_flag_dia] == 0].index)

df_volume = pd.DataFrame(0.0, index=beneficiarios_total.index, columns=range(NUM_DIAS))
df_entregas = pd.DataFrame(0, index=beneficiarios_total.index, columns=range(NUM_DIAS))

df_volume.iloc[:, 0] = capacidade_cisterna

start_time = time.time()

for i in range(1, NUM_DIAS):
    volume_atual = df_volume.iloc[:, i-1].values
    volume_pos_consumo = volume_atual - consumo_diario
    entregas_no_dia = np.zeros(len(beneficiarios_total))
    
    if i in indices_dias_nao_uteis:
        volume_final = np.where(volume_pos_consumo < 0, 0, volume_pos_consumo)
    else:
        espaco_livre = capacidade_cisterna - volume_pos_consumo
        numero_caminhoes = espaco_livre // CAPACIDADE_CAMINHAO
        precisa_abastecer = volume_pos_consumo < consumo_diario 
        
        qtd_entregar = np.where(precisa_abastecer, numero_caminhoes, 0)
        qtd_entregar = np.where((volume_pos_consumo <= 0) & (qtd_entregar == 0), 1, qtd_entregar)
        
        volume_abastecido = qtd_entregar * CAPACIDADE_CAMINHAO
        volume_final = volume_pos_consumo + volume_abastecido
        
        nao_uteis_consecutivos = 0
        idx_check = i + 1
        while idx_check < NUM_DIAS and idx_check in indices_dias_nao_uteis:
            nao_uteis_consecutivos += 1
            idx_check += 1
            
        if nao_uteis_consecutivos > 0:
            ajuste_necessario = consumo_diario * nao_uteis_consecutivos
            condicao_feriado = (volume_final - ajuste_necessario) <= 0
            volume_final = np.where(condicao_feriado, volume_final + CAPACIDADE_CAMINHAO, volume_final)
            qtd_entregar = np.where(condicao_feriado, qtd_entregar + 1, qtd_entregar)

        entregas_no_dia = qtd_entregar

    volume_final = np.where(volume_final > capacidade_cisterna, capacidade_cisterna, volume_final)
    volume_final = np.where(volume_final < 0, 0, volume_final)
    df_volume.iloc[:, i] = volume_final
    df_entregas.iloc[:, i] = entregas_no_dia

df_volume.columns = range(1, NUM_DIAS + 1)
df_entregas.columns = range(1, NUM_DIAS + 1)
df_volume.insert(0, 'Beneficiarios', beneficiarios_total.index + 1)
df_entregas.insert(0, 'Beneficiarios', beneficiarios_total.index + 1)

output_dir = Path(paths["results"]) / "limited_supply"
output_dir.mkdir(parents=True, exist_ok=True)

df_volume.to_csv(output_dir / "volumes_diarios.csv", index=False)
df_entregas.to_csv(output_dir / "abastecimento_diario.csv", index=False)
print(f"Resultados salvos em {output_dir}")
