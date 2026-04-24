# Allocation Heuristics / Heurísticas de Alocação

This directory contains fast heuristic algorithms to approximate the water allocation problem.
Este diretório contém algoritmos heurísticos rápidos para aproximar o problema de alocação de água.

## Heuristics / Heurísticas

### 1. Daily Flexible Allocation / Alocação Diária Flexível (`daily_flexible_allocation.py`)
- **Description**: A greedy approach to allocate sources to beneficiaries on a daily basis, following the logic of model M1.
- **Descrição**: Uma abordagem gulosa para alocar fontes aos beneficiários diariamente, seguindo a lógica do modelo M1.

### 2. Annual Fixed Allocation / Alocação Anual Fixa (`annual_fixed_allocation.py`)
- **Description**: Assigns each beneficiary to its nearest available water source for the entire period, approximating model M2.
- **Descrição**: Atribui cada beneficiário ao manancial disponível mais próximo para todo o período, aproximando o modelo M2.

## Glossary of Variables / Glossário de Variáveis
- `total_beneficiaries`: Number of beneficiaries to process. / Número de beneficiários a processar.
- `total_water_sources`: Number of sources available. / Número de mananciais disponíveis.
- `max_capacity_source`: Max trucks per source per day. / Máximo de caminhões por manancial por dia.
