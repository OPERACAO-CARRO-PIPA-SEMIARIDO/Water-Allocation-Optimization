# Integrated Models / Modelos Integrados

This directory contains models that combine source allocation and delivery scheduling into a single optimization problem.
Este diretório contém modelos que combinam a alocação de fontes e o agendamento de entregas em um único problema de otimização.

## Models / Modelos

### 1. Integrated Full Model / Modelo Integrado Completo (`integrated_full_model.jl`)
- **Description**: Optimizes both the assignment of sources to beneficiaries and the daily delivery schedule simultaneously for the entire horizon.
- **Descrição**: Otimiza simultaneamente a atribuição de fontes aos beneficiários e o cronograma de entrega diário para todo o horizonte.

### 2. Integrated Rolling Window / Modelo Integrado via Janela Deslizante (`integrated_rolling_window.jl`)
- **Description**: Solves the integrated problem in smaller time windows to improve performance and scalability.
- **Descrição**: Resolve o problema integrado em janelas de tempo menores para melhorar o desempenho e a escalabilidade.

## Glossary of Variables / Glossário de Variáveis

### Model Parameters / Parâmetros do Modelo
- `NUM_CANDIDATOS`: Number of closest water sources considered for each beneficiary. / Número de mananciais mais próximos considerados para cada beneficiário.
- `window_size`: Size of the rolling window (in days). / Tamanho da janela deslizante (em dias).
- `overlap`: Overlap between consecutive windows. / Sobreposição entre janelas consecutivas.

### Decision Variables / Variáveis de Decisão
- `z[j, i]`: Binary; 1 if beneficiary `j` is assigned to source `i`. / Binária; 1 se o beneficiário `j` for alocado ao manancial `i`.
- `x[j, i, k]`: Integer; trucks from source `i` to beneficiary `j` on day `k`. / Inteira; caminhões do manancial `i` para o beneficiário `j` no dia `k`.
- `y_pico`: Maximum daily peak of trucks. / Pico máximo diário de caminhões.

## Configuration / Configuração (`config.json`)
- `time_checkpoints_hours`: Time limits for intermediate result saving. / Limites de tempo para salvamento de resultados intermediários.
