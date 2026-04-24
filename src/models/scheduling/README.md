# Supply Scheduling Models / Modelos de Agendamento de Abastecimento

This directory contains models to optimize the timing of water deliveries to minimize daily peaks.
Este diretório contém modelos para otimizar o cronograma de entregas de água para minimizar picos diários.

## Peak Minimization / Minimização de Picos (`peak_minimization.jl`)

This model decides which day each beneficiary should receive water, considering their consumption rate and tank capacity, to flatten the demand for water trucks.
Este modelo decide em qual dia cada beneficiário deve receber água, considerando sua taxa de consumo e capacidade da cisterna, para nivelar a demanda por caminhões-pipa.

## Glossary of Variables / Glossário de Variáveis

### Model Parameters / Parâmetros do Modelo
- `U[j]`: Daily water consumption of beneficiary `j`. / Consumo diário de água do beneficiário `j`.
- `C[j]`: Storage capacity of beneficiary `j`. / Capacidade de armazenamento do beneficiário `j`.
- `qtd_dias_uteis`: Total number of available delivery days. / Número total de dias úteis para entrega.
- `p_valor`: Objective weight (0 to 1) balancing peak reduction vs. total deliveries. / Peso no objetivo (0 a 1) equilibrando redução de picos vs. total de entregas.

### Decision Variables / Variáveis de Decisão
- `x[j, k]`: Number of truckloads delivered to beneficiary `j` on day `k`. / Número de caminhões entregues ao beneficiário `j` no dia `k`.
- `V[j, k]`: Volume of water in tank `j` at the end of day `k`. / Volume de água na cisterna `j` ao final do dia `k`.
- `y`: Maximum daily peak of trucks. / Pico máximo diário de caminhões.

## Configuration / Configuração (`config.json`)
- `use_warm_start`: Whether to use a previous solution as a starting point. / Se deve usar uma solução anterior como ponto de partida.
- `time_checkpoints_minutes`: Time limits for intermediate result saving. / Limites de tempo para salvamento de resultados intermediários.
