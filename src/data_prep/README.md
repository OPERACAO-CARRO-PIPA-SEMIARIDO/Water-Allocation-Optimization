# Data Preparation

This module contains scripts to prepare the spatial data required by the optimization models.

## Route Generator (`route_generator.py`)

This script calculates the distance matrix between all water sources and beneficiaries using an OSRM (Open Source Routing Machine) instance.

### Execution and Output

The script can be executed via Python:
```bash
python route_generator.py
```

- **Output Format**: CSV file.
- **Output Naming**: `rotas.csv`.
- **Output Location**: Saved in the directory specified by `paths["results"]` in `config.json`.

### Configuration (`config.json`)

The script uses parameters from the `config.json` file:

#### Paths (`paths`)
- `base_data`: Directory containing the input CSV files (`Beneficiarios_RN_Ativos1.csv` and `Mananciais_RN.csv`).
- `results`: Directory where the output `rotas.csv` will be saved.

#### Parameters (`parameters`)
- `osrm_url`: The URL of the OSRM service (e.g., `https://router.project-osrm.org/table/v1/driving/`).

### Glossary of Variables
- `coords_fontes`: Coordinates (longitude, latitude) of water sources.
- `coords_beneficiarios`: Coordinates (longitude, latitude) of beneficiaries.
- `MAPA_MULTIPLICADOR`: Dictionary of multipliers applied to distances based on road conditions.

---

# Preparação de Dados

Este módulo contém scripts para preparar os dados espaciais necessários para os modelos de otimização.

## Gerador de Rotas (`route_generator.py`)

Este script calcula a matriz de distâncias entre todos os mananciais e beneficiários utilizando uma instância do OSRM.

### Execução e Saída

O script pode ser executado via Python:
```bash
python route_generator.py
```

- **Formato de Saída**: Arquivo CSV.
- **Nomenclatura**: `rotas.csv`.
- **Localização**: Salvo no diretório especificado por `paths["results"]` no `config.json`.

### Configuração (`config.json`)

O script utiliza parâmetros do arquivo `config.json`:

#### Caminhos (`paths`)
- `base_data`: Diretório que contém os arquivos CSV de entrada (`Beneficiarios_RN_Ativos1.csv` e `Mananciais_RN.csv`).
- `results`: Diretório onde o arquivo `rotas.csv` será salvo.

#### Parâmetros (`parameters`)
- `osrm_url`: A URL do serviço OSRM (ex: `https://router.project-osrm.org/table/v1/driving/`).

### Glossário de Variáveis
- `coords_fontes`: Coordenadas (longitude, latitude) dos mananciais.
- `coords_beneficiarios`: Coordenadas (longitude, latitude) dos beneficiários.
- `MAPA_MULTIPLICADOR`: Dicionário de multiplicadores aplicados às distâncias baseados na condição da estrada.
