# Integrated Models

This directory contains models that combine source allocation and delivery scheduling into a single optimization problem.

## Models

### 1. Integrated Full Model (`integrated_full_model.jl`)
- **Description**: Optimizes both the assignment of sources to beneficiaries and the daily delivery schedule simultaneously for the entire horizon.

### 2. Integrated Rolling Window (`integrated_rolling_window.jl`)
- **Description**: Solves the integrated problem in smaller time windows to improve performance and scalability.

## Glossary of Variables

### Model Parameters
- `NUM_CANDIDATOS`: Number of closest water sources considered for each beneficiary.
- `window_size`: Size of the rolling window (in days).
- `overlap`: Overlap between consecutive windows.

### Decision Variables
- `z[j, i]`: Binary; 1 if beneficiary `j` is assigned to source `i`.
- `x[j, i, k]`: Integer; trucks from source `i` to beneficiary `j` on day `k`.
- `y_pico`: Maximum daily peak of trucks.

---

# Modelos Integrados

Este diretório contém modelos que combinam a alocação de fontes e o agendamento de entregas em um único problema de otimização.

## Modelos

### 1. Modelo Integrado Completo (`integrated_full_model.jl`)
- **Descrição**: Otimiza simultaneamente a atribuição de fontes aos beneficiários e o cronograma de entrega diário para todo o horizonte.

### 2. Modelo Integrado via Janela Deslizante (`integrated_rolling_window.jl`)
- **Descrição**: Resolve o problema integrado em janelas de tempo menores para melhorar o desempenho e a escalabilidade.

## Glossário de Variáveis

### Parâmetros do Modelo
- `NUM_CANDIDATOS`: Número de mananciais mais próximos considerados para cada beneficiário.
- `window_size`: Tamanho da janela deslizante (em dias).
- `overlap`: Sobreposição entre janelas consecutivas.

### Variáveis de Decisão
- `z[j, i]`: Binária; 1 se o beneficiário `j` for alocado ao manancial `i`.
- `x[j, i, k]`: Inteira; caminhões do manancial `i` para o beneficiário `j` no dia `k`.
- `y_pico`: Pico máximo diário de caminhões.
