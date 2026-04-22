# Otimização de Abastecimento de Água

Este repositório contém a versão oficial dos modelos matemáticos e heurísticas desenvolvidos para a otimização da alocação de recursos hídricos e minimização de picos de abastecimento por carros-pipa.

*For the English version, see [README.md](README.md).*

## Estrutura do Projeto

O código está organizado por domínio para garantir modularidade. Cada módulo possui o seu próprio arquivo `config.json` local.

```text
src/
├── data_prep/          # Scripts para geração de rotas e cálculo de distâncias via OSRM.
├── models/             # Modelos exatos em Julia (JuMP/Gurobi).
│   ├── allocation/     # Modelos de alocação M1 (diário/flexível) e M2 (anual/fixo).
│   ├── scheduling/     # Modelo focado na redução de picos diários de abastecimento.
│   └── integrated/     # Modelo integrado completo e versão via Rolling Horizon.
├── heuristics/         # Algoritmos gulosos e simulações em Python.
│   ├── allocation/     # Aproximações rápidas para as regras do M1 e M2.
│   └── scheduling/     # Simulações de base ("Calendário Full" e "Calendário Limite").
└── utils/              # Carregadores de configuração compartilhados.
```

## Requisitos
- **Julia** 1.9+
- **Python** 3.8+
- **Gurobi Optimizer** (Necessária licença válida para rodar os modelos em Julia)

## Como Usar
1. Coloque os arquivos CSV de entrada (`Beneficiarios_RN_Ativos1.csv`, `datas.csv`, `rotas.csv`, etc.) dentro da pasta `data/`.
2. Edite o `config.json` de acordo com a pasta do modelo que você deseja rodar.
3. Instale as dependências:
   - Python: `pip install -r requirements.txt`
   - Julia: `julia --project=. -e 'using Pkg; Pkg.instantiate()'`
