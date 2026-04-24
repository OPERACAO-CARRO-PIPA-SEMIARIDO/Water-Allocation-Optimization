# Data Preparation / Preparação de Dados

This module contains scripts to prepare the spatial data required by the optimization models.
Este módulo contém scripts para preparar os dados espaciais necessários para os modelos de otimização.

## Route Generator / Gerador de Rotas (`route_generator.py`)

This script calculates the distance matrix between all water sources and beneficiaries using an OSRM (Open Source Routing Machine) instance.
Este script calcula a matriz de distâncias entre todos os mananciais e beneficiários utilizando uma instância do OSRM.

### Parameters / Parâmetros (`config.json`)
- `osrm_url`: The URL of the OSRM service. / A URL do serviço OSRM.

### Glossary of Variables / Glossário de Variáveis
- `base_data`: Path to input CSV files. / Caminho para os arquivos CSV de entrada.
- `results`: Path to save the generated route matrix. / Caminho para salvar a matriz de rotas gerada.

---

[Português]

## Descrição
O script `route_generator.py` lê as coordenadas geográficas dos beneficiários e mananciais e consulta um servidor OSRM para obter as distâncias reais de condução, aplicando um fator de correção se necessário, e salva o resultado em um arquivo `rotas.csv`.
