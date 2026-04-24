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
