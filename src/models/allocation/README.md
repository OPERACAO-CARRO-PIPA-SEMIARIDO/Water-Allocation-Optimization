# Water Allocation Models

This directory contains exact mathematical models (MILP) to solve the source-to-beneficiary allocation problem.

## Models

### 1. Daily Flexible Allocation (M1)
- **File**: `daily_flexible_allocation.jl`
- **Description**: Solves the allocation daily. A beneficiary can receive water from different sources on different days.

### 2. Annual Fixed Allocation (M2)
- **File**: `annual_fixed_allocation.jl`
- **Description**: Each beneficiary is assigned to a single water source for the entire year, minimizing total transportation cost.

### Execution and Output

The models can be executed via Julia:
```bash
julia daily_flexible_allocation.jl <ABASTECIMENTO_CSV> <OUTPUT_ALOCACAO_CSV> <OUTPUT_CUSTO_CSV>
julia annual_fixed_allocation.jl <ABASTECIMENTO_CSV> <OUTPUT_ALOCACAO_CSV> <OUTPUT_CUSTO_CSV>
```

- **Output Format**: CSV files.
- **Output Naming**: Defined by the command line arguments.
- **Output Location**: Typically saved in the directory specified by `paths["results"]` in the local `config.json`.

### Configuration (`config.json`)

The models use parameters from the `config.json` files:

#### Paths (`paths`)
- `results`: Directory for output files (defined in `src/models/allocation/config.json`).
- `beneficiaries`: Path to the active beneficiaries CSV.
- `routes`: Path to the route matrix CSV.

#### Parameters (`parameters`)
- `total_beneficiaries`: Total number of beneficiaries.
- `total_water_sources`: Total number of water sources.
- `max_capacity_source`: Max daily truckloads per source.
- `mip_gap`: Optimality gap tolerance (e.g., `0.002`).
- `threads`: Number of CPU threads for the solver.

## Glossary of Variables

### Model Parameters
- `NM_TOTAL`: Total number of water sources.
- `NUM_BENEFICIARIOS`: Total number of beneficiaries.
- `CAPACIDADE_MAX`: Max daily truckloads per source.
- `Dij`: Distance between source `i` and beneficiary `j`.
- `Ajk`: Demand (truckloads) of beneficiary `j` on day `k`.

### Decision Variables
- `x[i, j, k]`: Integer variable; number of trucks from source `i` to beneficiary `j` on day `k`.
- `y[i, j]`: Binary variable (M2); 1 if beneficiary `j` is assigned to source `i`.

---

# Modelos de Alocação de Água

Este diretório contém modelos matemáticos exatos (MILP) para resolver o problema de alocação de mananciais para beneficiários.

## Modelos

### 1. Alocação Diária Flexível (M1)
- **Arquivo**: `daily_flexible_allocation.jl`
- **Descrição**: Resolve a alocação diariamente. Um beneficiário pode receber água de diferentes fontes em dias diferentes.

### 2. Alocação Anual Fixa (M2)
- **Arquivo**: `annual_fixed_allocation.jl`
- **Descrição**: Cada beneficiário é vinculado a um único manancial para o ano inteiro, minimizando o custo total de transporte.

### Execução e Saída

Os modelos podem ser executados via Julia:
```bash
julia daily_flexible_allocation.jl <ABASTECIMENTO_CSV> <OUTPUT_ALOCACAO_CSV> <OUTPUT_CUSTO_CSV>
julia annual_fixed_allocation.jl <ABASTECIMENTO_CSV> <OUTPUT_ALOCACAO_CSV> <OUTPUT_CUSTO_CSV>
```

- **Formato de Saída**: Arquivos CSV.
- **Nomenclatura**: Definida pelos argumentos de linha de comando.
- **Localização**: Tipicamente salvos no diretório especificado por `paths["results"]` no `config.json` local.

### Configuração (`config.json`)

Os modelos utilizam parâmetros dos arquivos `config.json`:

#### Caminhos (`paths`)
- `results`: Diretório para arquivos de saída (definido em `src/models/allocation/config.json`).
- `beneficiaries`: Caminho para o CSV de beneficiários ativos.
- `routes`: Caminho para o CSV da matriz de rotas.

#### Parâmetros (`parameters`)
- `total_beneficiaries`: Número total de beneficiários.
- `total_water_sources`: Número total de mananciais.
- `max_capacity_source`: Máximo de caminhões por manancial por dia.
- `mip_gap`: Tolerância de gap de otimalidade (ex: `0.002`).
- `threads`: Número de threads de CPU para o solver.

## Glossário de Variáveis

### Parâmetros do Modelo
- `NM_TOTAL`: Número total de mananciais.
- `NUM_BENEFICIARIOS`: Número total de beneficiários.
- `CAPACIDADE_MAX`: Capacidade máxima diária de caminhões por manancial.
- `Dij`: Distância entre o manancial `i` e o beneficiário `j`.
- `Ajk`: Demanda (caminhões) do beneficiário `j` no dia `k`.

### Variáveis de Decisão
- `x[i, j, k]`: Variável inteira; número de caminhões do manancial `i` para o beneficiário `j` no dia `k`.
- `y[i, j]`: Variável binária (M2); 1 se o beneficiário `j` for alocado ao manancial `i`.
