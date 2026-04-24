# Scheduling Heuristics

This directory contains rule-based simulations to generate delivery schedules.

## Heuristics

### 1. Full Supply Schedule (`full_supply_schedule.py`)
- **Description**: Delivers water whenever there is space in the tank, attempting to keep tanks full.

### 2. Limited Supply Schedule (`limited_supply_schedule.py`)
- **Description**: Only delivers water when the volume is about to run out (Just-in-Time).

## Glossary of Variables
- `truck_capacity`: Capacity of a single water truck (standardized at 13.0m³).
- `total_days`: Number of days in the simulation.
- `volume_atual`: Current water volume in the beneficiary's tank.

---

# Heurísticas de Agendamento

Este diretório contém simulações baseadas em regras para gerar cronogramas de entrega.

## Heurísticas

### 1. Cronograma de Abastecimento Completo (`full_supply_schedule.py`)
- **Descrição**: Entrega água sempre que há espaço na cisterna, tentando mantê-las cheias.

### 2. Cronograma de Abastecimento Limitado (`limited_supply_schedule.py`)
- **Descrição**: Só entrega água quando o volume está prestes a acabar (Just-in-Time).

## Glossário de Variáveis
- `truck_capacity`: Capacidade de um único caminhão-pipa (padronizado em 13,0m³).
- `total_days`: Número de dias na simulação.
- `volume_atual`: Volume atual de água na cisterna do beneficiário.
