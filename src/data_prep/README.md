# Data Preparation

This module contains scripts to prepare the spatial data required by the optimization models.

## Route Generator (`route_generator.py`)

This script calculates the distance matrix between all water sources and beneficiaries using an OSRM (Open Source Routing Machine) instance.

### Parameters (`config.json`)
- `osrm_url`: The URL of the OSRM service.

### Glossary of Variables
- `base_data`: Path to input CSV files.
- `results`: Path to save the generated route matrix.

---

# Preparação de Dados

Este módulo contém scripts para preparar os dados espaciais necessários para os modelos de otimização.

## Gerador de Rotas (`route_generator.py`)

Este script calcula a matriz de distâncias entre todos os mananciais e beneficiários utilizando uma instância do OSRM.

### Parâmetros (`config.json`)
- `osrm_url`: A URL do serviço OSRM.

### Glossário de Variáveis
- `base_data`: Caminho para os arquivos CSV de entrada.
- `results`: Caminho para salvar a matriz de rotas gerada.
