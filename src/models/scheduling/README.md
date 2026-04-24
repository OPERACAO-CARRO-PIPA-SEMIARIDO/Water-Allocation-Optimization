# Supply Scheduling Models

This directory contains models to optimize the timing of water deliveries to minimize daily peaks.

## Peak Minimization (`peak_minimization.jl`)

This model decides which day each beneficiary should receive water, considering their consumption rate and tank capacity, to flatten the demand for water trucks.

## Glossary of Variables

### Model Parameters
- `U[j]`: Daily water consumption of beneficiary `j`.
- `C[j]`: Storage capacity of beneficiary `j`.
- `qtd_dias_uteis`: Total number of available delivery days.
- `p_valor`: Objective weight (0 to 1) balancing peak reduction vs. total deliveries.

### Decision Variables
- `x[j, k]`: Number of truckloads delivered to beneficiary `j` on day `k`.
- `V[j, k]`: Volume of water in tank `j` at the end of day `k`.
- `y`: Maximum daily peak of trucks.

---

# Modelos de Agendamento de Abastecimento

Este diretório contém modelos para otimizar o cronograma de entregas de água para minimizar picos diários.

## Minimização de Picos (`peak_minimization.jl`)

Este modelo decide em qual dia cada beneficiário deve receber água, considerando sua taxa de consumo e capacidade da cisterna, para nivelar a demanda por caminhões-pipa.

## Glossário de Variáveis

### Parâmetros do Modelo
- `U[j]`: Consumo diário de água do beneficiário `j`.
- `C[j]`: Capacidade de armazenamento do beneficiário `j`.
- `qtd_dias_uteis`: Número total de dias úteis para entrega.
- `p_valor`: Peso no objetivo (0 a 1) equilibrando redução de picos vs. total de entregas.

### Variáveis de Decisão
- `x[j, k]`: Número de caminhões entregues ao beneficiário `j` no dia `k`.
- `V[j, k]`: Volume de água na cisterna `j` ao final do dia `k`.
- `y`: Pico máximo diário de caminhões.
