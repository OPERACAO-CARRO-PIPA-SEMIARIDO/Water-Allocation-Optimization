# Water Allocation Models / Modelos de Alocação de Água

This directory contains exact mathematical models (MILP) to solve the source-to-beneficiary allocation problem.
Este diretório contém modelos matemáticos exatos (MILP) para resolver o problema de alocação de mananciais para beneficiários.

## Models / Modelos

### 1. Daily Flexible Allocation / Alocação Diária Flexível (M1)
- **File / Arquivo**: `daily_flexible_allocation.jl`
- **Description**: Solves the allocation daily. A beneficiary can receive water from different sources on different days.
- **Descrição**: Resolve a alocação diariamente. Um beneficiário pode receber água de diferentes fontes em dias diferentes.

### 2. Annual Fixed Allocation / Alocação Anual Fixa (M2)
- **File / Arquivo**: `annual_fixed_allocation.jl`
- **Description**: Each beneficiary is assigned to a single water source for the entire year, minimizing total transportation cost.
- **Descrição**: Cada beneficiário é vinculado a um único manancial para o ano inteiro, minimizando o custo total de transporte.

## Glossary of Variables / Glossário de Variáveis

### Model Parameters / Parâmetros do Modelo
- `NM_TOTAL`: Total number of water sources. / Número total de mananciais.
- `NUM_BENEFICIARIOS`: Total number of beneficiaries. / Número total de beneficiários.
- `CAPACIDADE_MAX`: Max daily truckloads per source. / Capacidade máxima diária de caminhões por manancial.
- `Dij`: Distance between source `i` and beneficiary `j`. / Distância entre o manancial `i` e o beneficiário `j`.
- `Ajk`: Demand (truckloads) of beneficiary `j` on day `k`. / Demanda (caminhões) do beneficiário `j` no dia `k`.

### Decision Variables / Variáveis de Decisão
- `x[i, j, k]`: Integer variable; number of trucks from source `i` to beneficiary `j` on day `k`. / Variável inteira; número de caminhões do manancial `i` para o beneficiário `j` no dia `k`.
- `y[i, j]`: Binary variable (M2); 1 if beneficiary `j` is assigned to source `i`. / Variável binária (M2); 1 se o beneficiário `j` for alocado ao manancial `i`.

## Configuration / Configuração (`config.json`)
- `threads`: Number of CPU threads for the solver. / Número de threads do CPU para o solver.
- `mip_gap`: Tolerance for the optimality gap. / Tolerância para o gap de otimalidade.
