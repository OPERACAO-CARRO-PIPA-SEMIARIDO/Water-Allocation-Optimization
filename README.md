# Water-Allocation-Optimization

This repository contains the mathematical models, algorithms, and heuristics developed to optimize the allocation of water resources and truck routes for drought relief operations.

*Para a versão em Português, veja [README_ptBR.md](README_ptBR.md).*

## Repository Structure

The code is organized by domain and methodology to ensure modularity and ease of use. Each specific module contains its own local `config.json`.

```text
src/
├── data_prep/          # Scripts for generating real distance matrices using OSRM.
├── models/             # Exact mathematical models in Julia (JuMP/Gurobi).
│   ├── allocation/     # M1 (daily flexible) and M2 (annual fixed) source allocation.
│   ├── scheduling/     # Supply scheduling models focused on peak minimization.
│   └── integrated/     # Full integrated routing/allocation model + Rolling Horizon.
├── heuristics/         # Greedy algorithms and simulations in Python.
│   ├── allocation/     # Fast greedy approximations for M1 and M2.
│   └── scheduling/     # "Full Supply" and "Limited Supply" simulation baselines.
└── utils/              # Shared configuration loaders.
```

## Requirements
- **Julia** 1.9+
- **Python** 3.8+
- **Gurobi Optimizer** (Valid license required for exact models)

## Getting Started
1. Place the input datasets (`Beneficiarios_RN_Ativos1.csv`, `datas.csv`, `rotas.csv`, etc.) into the `data/` directory.
2. Adjust `config.json` inside the module you wish to execute.
3. Install dependencies:
   - Python: `pip install -r requirements.txt`
   - Julia: `julia --project=. -e 'using Pkg; Pkg.instantiate()'`
