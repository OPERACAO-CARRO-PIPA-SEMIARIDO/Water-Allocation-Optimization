# Water Allocation Optimization / Otimização de Alocação de Água

[English](#english) | [Português](#português)

---

## English

This repository contains mathematical models, algorithms, and heuristics developed to optimize the allocation of water resources and truck routes for drought relief operations.

### Repository Structure

The code is organized by domain and methodology. Each module contains its own local `README.md` and `config.json`.

- **Global Config**: `config.json` at the root contains shared parameters and paths.
- `src/data_prep/`: Scripts for generating distance matrices using OSRM.
- `src/models/`: Exact mathematical models in Julia (JuMP/Gurobi).
    - `allocation/`: M1 (daily flexible) and M2 (annual fixed) source allocation.
    - `scheduling/`: Supply scheduling models focused on peak minimization.
    - `integrated/`: Full integrated routing/allocation model + Rolling Horizon.
- `src/heuristics/`: Greedy algorithms and simulations in Python.
    - `allocation/`: Fast greedy approximations for M1 and M2.
    - `scheduling/`: "Full Supply" and "Limited Supply" simulation baselines.
- `src/utils/`: Shared configuration loaders.

### Requirements
- **Julia** 1.9+
- **Python** 3.8+
- **Gurobi Optimizer** (Valid license required for exact models)

### Configuration / Configuração (`config.json`)

All models and scripts are controlled by the root `config.json`. / Todos os modelos e scripts são controlados pelo `config.json` na raiz.

#### Paths / Caminhos
- `base_data`: Root directory for input data. / Diretório raiz dos dados de entrada.
- `results`: Root directory for output. / Diretório raiz dos resultados.
- `beneficiaries`: Path to the beneficiaries CSV. / Caminho para o CSV de beneficiários.
- `dates`: Path to the dates/holidays CSV. / Caminho para o CSV de datas/feriados.
- `calendars`: Path to the mandatory calendars CSV. / Caminho para o CSV de calendários obrigatórios.
- `routes`: Path to the distance matrix CSV. / Caminho para o CSV da matriz de distâncias.
- `warm_start_file`: Path to a previous solution to speed up optimization. / Caminho para uma solução anterior para acelerar a otimização.
- `initial_volumes_file`: Path to initial tank volumes (Rolling Window). / Caminho para volumes iniciais das cisternas (Janela Deslizante).

#### Parameters / Parâmetros
- `total_beneficiaries`: Number of beneficiaries to include in the model. / Número de beneficiários a incluir no modelo.
- `total_water_sources`: Number of water sources to include. / Número de mananciais a incluir.
- `max_capacity_source`: Max trucks per source per day. / Máximo de caminhões por manancial por dia.
- `total_days`: Number of days in the optimization horizon. / Número de dias no horizonte de otimização.
- `truck_capacity`: Standard capacity of one truck (m³). / Capacidade padrão de um caminhão (m³).
- `time_checkpoints_hours`: List of hours to save intermediate solutions. / Lista de horas para salvar soluções intermediárias.
- `threads`: Number of CPU cores for the solver. / Número de núcleos do CPU para o solver.
- `mip_gap`: Tolerance for the solver's optimality gap. / Tolerância para o gap de otimalidade do solver.
- `p_value`: Weight for the multi-objective function (0 = focus on distance, 1 = focus on peaks). / Peso para a função multiobjetivo (0 = foco em distância, 1 = foco em picos).
- `num_candidates`: Number of closest sources considered per beneficiary (Integrated Model). / Número de mananciais mais próximos considerados por beneficiário (Modelo Integrado).
- `window_size`: Duration of each time window (Rolling Window). / Duração de cada janela de tempo (Janela Deslizante).
- `overlap`: Number of overlapping days between windows. / Número de dias de sobreposição entre janelas.
- `osrm_url`: URL for the OSRM routing engine. / URL para o motor de rotas OSRM.

---

### Getting Started
1. Place input datasets (`Beneficiarios_RN_Ativos1.csv`, `datas.csv`, `rotas.csv`, etc.) into the `data/` directory.
2. Adjust the global `config.json` or local ones inside the module directories.
3. Install dependencies:
   - Python: `pip install -r requirements.txt`
   - Julia: `julia --project=. -e 'using Pkg; Pkg.instantiate()'`

---

## Português

Este repositório contém os modelos matemáticos e heurísticas desenvolvidos para a otimização da alocação de recursos hídricos e minimização de picos de abastecimento por carros-pipa.

### Estrutura do Projeto

O código está organizado por domínio. Cada módulo possui o seu próprio `README.md` e `config.json`.

- **Configuração Global**: O arquivo `config.json` na raiz contém parâmetros e caminhos compartilhados.
- `src/data_prep/`: Scripts para geração de rotas e cálculo de distâncias via OSRM.
- `src/models/`: Modelos exatos em Julia (JuMP/Gurobi).
    - `allocation/`: Modelos de alocação M1 (diário/flexível) e M2 (anual/fixo).
    - `scheduling/`: Modelo focado na redução de picos diários de abastecimento.
    - `integrated/`: Modelo integrado completo e versão via Janela Deslizante.
- `src/heuristics/`: Algoritmos gulosos e simulações em Python.
    - `allocation/`: Aproximações rápidas para as regras do M1 e M2.
    - `scheduling/`: Simulações de base ("Calendário Full" e "Calendário Limite").
- `src/utils/`: Carregadores de configuração compartilhados.

### Requisitos
- **Julia** 1.9+
- **Python** 3.8+
- **Gurobi Optimizer** (Necessária licença válida para rodar os modelos em Julia)

### Como Usar
1. Coloque os arquivos CSV de entrada na pasta `data/`.
2. Edite o `config.json` global ou os arquivos locais nos diretórios dos modelos.
3. Instale as dependências:
   - Python: `pip install -r requirements.txt`
   - Julia: `julia --project=. -e 'using Pkg; Pkg.instantiate()'`
