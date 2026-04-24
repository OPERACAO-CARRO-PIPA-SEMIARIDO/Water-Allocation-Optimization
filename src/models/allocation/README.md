# Water Allocation Models

This directory contains exact mathematical models (MILP) to solve the source-to-beneficiary allocation problem.

## Models

### 1. Daily Flexible Allocation (M1)
- **File**: `daily_flexible_allocation.jl`
- **Description**: Solves the allocation daily. A beneficiary can receive water from different sources on different days.

### 2. Annual Fixed Allocation (M2)
- **File**: `annual_fixed_allocation.jl`
- **Description**: Each beneficiary is assigned to a single water source for the entire year, minimizing total transportation cost.

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
