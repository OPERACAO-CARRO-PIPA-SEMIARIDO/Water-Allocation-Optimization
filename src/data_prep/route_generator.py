import pandas as pd
import numpy as np
import requests
import os
import sys
import time
from pathlib import Path

# Load config
sys.path.append(str(Path(__file__).parent.parent))
from utils.config_loader import load_config

config = load_config()
paths = config["paths"]
params = config["parameters"]

# Settings
BASE_DATA_DIR = Path(paths["base_data"])
ARQUIVO_BENEFICIARIOS = BASE_DATA_DIR / "Beneficiarios_RN_Ativos1.csv"
ARQUIVO_MANANCIAIS = BASE_DATA_DIR / "Mananciais_RN.csv"
ARQUIVO_SAIDA_ROTAS = Path(paths["results"]) / "rotas.csv"
OSRM_PUBLIC_URL = params["osrm_url"]

# Multipliers based on road condition
MAPA_MULTIPLICADOR = {
    'Não definido': 0.79,
    'Regular': 0.71,
    'Boa': 0.68,
    'Ruim': 0.79,
    'Péssima': 0.85
}
VALOR_PADRAO_MULT = 0.74

def limpar_coordenada(serie):
    if serie.dtype == object:
        return serie.str.replace('"', '', regex=False).str.replace(',', '.', regex=False).astype(float)
    return serie.astype(float)

def obter_distancias_online(coords_fontes, coords_beneficiarios):
    all_coords = coords_fontes + coords_beneficiarios
    coords_str = ";".join(all_coords)
    sources = ";".join([str(i) for i in range(len(coords_fontes))])
    destinations = ";".join([str(i + len(coords_fontes)) for i in range(len(coords_beneficiarios))])
    url = f"{OSRM_PUBLIC_URL}{coords_str}?sources={sources}&destinations={destinations}&annotations=distance"
    
    try:
        response = requests.get(url, timeout=45)
        if response.status_code == 200:
            data = response.json()
            if data.get("code") == "Ok":
                return np.array(data["distances"]) / 1000.0 # Convert to km
        elif response.status_code == 429:
            print("Aviso: Muitas requisições. Aguardando pausa técnica...")
            time.sleep(10)
    except Exception as e:
        print(f"Erro de conexão: {e}")
    return None

def processar_rotas():
    print("--- Gerando Rotas via API Online OSRM ---")
    ARQUIVO_SAIDA_ROTAS.parent.mkdir(parents=True, exist_ok=True)
    
    try:
        df_ben = pd.read_csv(ARQUIVO_BENEFICIARIOS, encoding='utf-8')
        df_man = pd.read_csv(ARQUIVO_MANANCIAIS, encoding='utf-8')
    except UnicodeDecodeError:
        df_ben = pd.read_csv(ARQUIVO_BENEFICIARIOS, encoding='latin-1')
        df_man = pd.read_csv(ARQUIVO_MANANCIAIS, encoding='latin-1')
    except Exception as e:
        print(f"Erro ao abrir arquivos: {e}")
        return

    df_ben['lat'] = limpar_coordenada(df_ben['Latitude (Formato Decimal)'])
    df_ben['lon'] = limpar_coordenada(df_ben['Longitude (Formato Decimal)'])
    df_man['lat'] = limpar_coordenada(df_man['Latitude (Formato Decimal)'])
    df_man['lon'] = limpar_coordenada(df_man['Longitude (Formato Decimal)'])

    df_ben['mult'] = df_ben['Situação Estrada de Acesso'].map(MAPA_MULTIPLICADOR).fillna(VALOR_PADRAO_MULT)
    df_man['mult'] = df_man['Situação Estrada de Acesso'].map(MAPA_MULTIPLICADOR).fillna(VALOR_PADRAO_MULT)

    coords_man = [f"{lon},{lat}" for lon, lat in zip(df_man['lon'], df_man['lat'])]
    coords_ben = [f"{lon},{lat}" for lon, lat in zip(df_ben['lon'], df_ben['lat'])]

    num_ben = len(df_ben)
    num_man = len(df_man)
    resultados = []
    chunk_size = 50 
    
    print(f"Calculando rotas para {num_ben} beneficiários e {num_man} mananciais...")
    
    for i in range(0, num_ben, chunk_size):
        end_idx = min(i + chunk_size, num_ben)
        chunk_ben = coords_ben[i:end_idx]
        matriz_dist = obter_distancias_online(coords_man, chunk_ben)
        
        if matriz_dist is None:
            print(f"Falha no bloco {i}-{end_idx}. Tentando novamente em 5s...")
            time.sleep(5)
            matriz_dist = obter_distancias_online(coords_man, chunk_ben)
            if matriz_dist is None: continue

        for b_offset, b_idx in enumerate(range(i, end_idx)):
            mult_ben = df_ben.iloc[b_idx]['mult']
            for m_idx in range(num_man):
                dist_real = matriz_dist[m_idx, b_offset]
                mult_man = df_man.iloc[m_idx]['mult']
                fator_final = max(mult_ben, mult_man)
                
                resultados.append({
                    'id_beneficiario': b_idx,
                    'id_fonte': m_idx,
                    'distance': round(dist_real, 4),
                    'multiplicador_manancial': mult_man,
                    'multiplicador_beneficiario': mult_ben,
                    'distance_w_factor': round(dist_real * fator_final, 6)
                })
        
        print(f"Progresso: {end_idx}/{num_ben} processados.")
        time.sleep(1.2)

    df_final = pd.DataFrame(resultados)
    df_final.to_csv(ARQUIVO_SAIDA_ROTAS, index=False)
    print(f"\nSucesso! Arquivo gerado: {ARQUIVO_SAIDA_ROTAS}")

if __name__ == "__main__":
    # processar_rotas()
    pass