# Scheduling Heuristics / Heurísticas de Agendamento

This directory contains rule-based simulations to generate delivery schedules.
Este diretório contém simulações baseadas em regras para gerar cronogramas de entrega.

## Heuristics / Heurísticas

### 1. Full Supply Schedule / Cronograma de Abastecimento Completo (`full_supply_schedule.py`)
- **Description**: Delivers water whenever there is space in the tank, attempting to keep tanks full.
- **Descrição**: Entrega água sempre que há espaço na cisterna, tentando mantê-las cheias.

### 2. Limited Supply Schedule / Cronograma de Abastecimento Limitado (`limited_supply_schedule.py`)
- **Description**: Only delivers water when the volume is about to run out (Just-in-Time).
- **Descrição**: Só entrega água quando o volume está prestes a acabar (Just-in-Time).

## Glossary of Variables / Glossário de Variáveis
- `truck_capacity`: Capacity of a single water truck (standardized at 13.0m³). / Capacidade de um único caminhão-pipa (padronizado em 13,0m³).
- `total_days`: Number of days in the simulation. / Número de dias na simulação.
- `volume_atual`: Current water volume in the beneficiary's tank. / Volume atual de água na cisterna do beneficiário.
