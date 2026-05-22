# Scheduling Heuristics

This directory contains rule-based simulations to generate delivery schedules.

## Heuristics

### 1. Full Supply Schedule (`full_supply_schedule.py`)
- **Description**: Delivers water whenever there is space in the tank, attempting to keep tanks full.

### 2. Limited Supply Schedule (`limited_supply_schedule.py`)
- **Description**: Only delivers water when the volume is about to run out (Just-in-Time).

### Execution and Output

The heuristics can be executed via Python:
```bash
python full_supply_schedule.py
python limited_supply_schedule.py
```

- **Output Format**: CSV files.
- **Output Naming**:
  - `volumes_diarios.csv`: Daily water volume in each beneficiary's tank.
  - `abastecimento_diario.csv`: Daily number of truckloads delivered to each beneficiary.
- **Output Location**: Saved in the directory specified by `paths["results"]` in the local `config.json`.

### Configuration (`config.json`)

The heuristics use parameters from the `config.json` files:

#### Paths (`paths`)
- `results`: Directory for output files (defined in `src/heuristics/scheduling/config.json`).
- `beneficiaries`: Path to the active beneficiaries CSV.
- `dates`: Path to the calendar dates CSV.

#### Parameters (`parameters`)
- `total_beneficiaries`: Number of beneficiaries to process.
- `total_days`: Number of days in the simulation.
- `truck_capacity`: Capacity of a single water truck (standardized at 13.0m³).

## Glossary of Variables
- `truck_capacity`: Capacity of a single water truck.
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

### Execução e Saída

As heurísticas podem ser executadas via Python:
```bash
python full_supply_schedule.py
python limited_supply_schedule.py
```

- **Formato de Saída**: Arquivos CSV.
- **Nomenclatura**:
  - `volumes_diarios.csv`: Volume diário de água na cisterna de cada beneficiário.
  - `abastecimento_diario.csv`: Número diário de caminhões entregues a cada beneficiário.
- **Localização**: Salvos no diretório especificado por `paths["results"]` no `config.json` local.

### Configuração (`config.json`)

As heurísticas utilizam parâmetros dos arquivos `config.json`:

#### Caminhos (`paths`)
- `results`: Diretório para arquivos de saída (definido em `src/heuristics/scheduling/config.json`).
- `beneficiaries`: Caminho para o CSV de beneficiários ativos.
- `dates`: Caminho para o CSV de datas do calendário.

#### Parâmetros (`parameters`)
- `total_beneficiaries`: Número de beneficiários a processar.
- `total_days`: Número de dias na simulação.
- `truck_capacity`: Capacidade de um único caminhão-pipa (padronizado em 13,0m³).

## Glossário de Variables
- `truck_capacity`: Capacidade de um único caminhão-pipa.
- `total_days`: Número de dias na simulação.
- `volume_atual`: Volume atual de água na cisterna do beneficiário.
