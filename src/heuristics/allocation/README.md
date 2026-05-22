# Allocation Heuristics

This directory contains fast heuristic algorithms to approximate the water allocation problem.

## Heuristics

### 1. Daily Flexible Allocation (`daily_flexible_allocation.py`)
- **Description**: A greedy approach to allocate sources to beneficiaries on a daily basis, following the logic of model M1.
- **Output**: `alocacao_heuristica_diaria.csv`

### 2. Annual Fixed Allocation (`annual_fixed_allocation.py`)
- **Description**: Assigns each beneficiary to its nearest available water source for the entire period, approximating model M2.
- **Output**: `alocacao_heuristica_anual.csv`

### Execution and Output

The heuristics can be executed via Python:
```bash
python daily_flexible_allocation.py
python annual_fixed_allocation.py
```

- **Output Format**: CSV files.
- **Output Location**: Saved in the directory specified by `paths["results"]` in the local `config.json`.

### Configuration (`config.json`)

The heuristics use parameters from the `config.json` files:

#### Paths (`paths`)
- `results`: Directory for output files (defined in `src/heuristics/allocation/config.json`).
- `beneficiaries`: Path to the active beneficiaries CSV.
- `routes`: Path to the route matrix CSV.

#### Parameters (`parameters`)
- `total_beneficiaries`: Number of beneficiaries to process.
- `total_water_sources`: Number of sources available.
- `max_capacity_source`: Max trucks per source per day.

## Glossary of Variables
- `NM_TOTAL`: Total number of water sources.
- `NUM_BENEFICIARIOS`: Total number of beneficiaries.
- `CAPACIDADE_MAX`: Maximum daily truckloads per source.

---

# Heurísticas de Alocação

Este diretório contém algoritmos heurísticos rápidos para aproximar o problema de alocação de água.

## Heurísticas

### 1. Alocação Diária Flexível (`daily_flexible_allocation.py`)
- **Descrição**: Uma abordagem gulosa para alocar fontes aos beneficiários diariamente, seguindo a lógica do modelo M1.
- **Saída**: `alocacao_heuristica_diaria.csv`

### 2. Alocação Anual Fixa (`annual_fixed_allocation.py`)
- **Descrição**: Atribui cada beneficiário ao manancial disponível mais próximo para todo o período, aproximando o modelo M2.
- **Saída**: `alocacao_heuristica_anual.csv`

### Execução e Saída

As heurísticas podem ser executadas via Python:
```bash
python daily_flexible_allocation.py
python annual_fixed_allocation.py
```

- **Formato de Saída**: Arquivos CSV.
- **Localização**: Salvos no diretório especificado por `paths["results"]` no `config.json` local.

### Configuração (`config.json`)

As heurísticas utilizam parâmetros dos arquivos `config.json`:

#### Caminhos (`paths`)
- `results`: Diretório para arquivos de saída (definido em `src/heuristics/allocation/config.json`).
- `beneficiaries`: Caminho para o CSV de beneficiários ativos.
- `routes`: Caminho para o CSV da matriz de rotas.

#### Parâmetros (`parameters`)
- `total_beneficiaries`: Número de beneficiários a processar.
- `total_water_sources`: Número de mananciais disponíveis.
- `max_capacity_source`: Máximo de caminhões por manancial por dia.

## Glossário de Variáveis
- `NM_TOTAL`: Número total de mananciais.
- `NUM_BENEFICIARIOS`: Número total de beneficiários.
- `CAPACIDADE_MAX`: Capacidade máxima diária de caminhões por manancial.
