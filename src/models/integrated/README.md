# Integrated Models

This directory contains models that combine source allocation and delivery scheduling into a single optimization problem.

## Models

### 1. Integrated Full Model (`integrated_full_model.jl`)
- **Description**: Optimizes both the assignment of sources to beneficiaries and the daily delivery schedule simultaneously for the entire horizon.

### 2. Integrated Rolling Window (`integrated_rolling_window.jl`)
- **Description**: Solves the integrated problem in smaller time windows to improve performance and scalability.

### Execution and Output

The integrated models can be executed via Julia:
```bash
julia integrated_full_model.jl [p_value] [folder_name]
julia integrated_rolling_window.jl [p_value] [folder_name]
```

- **Output Format**: CSV files.
- **Output Naming**:
  - `abastecimento_$sufixo.csv`: Delivery schedule for the period.
  - `alocacao_$sufixo.csv`: Assignment of sources to beneficiaries.
  - `$sufixo` corresponds to checkpoint times (e.g., `3h`) or `melhor_absoluto`.
  - `volumes_todos_dias.csv`: (Rolling Window only) Consolidated tank volumes for the entire horizon.
- **Output Location**: Saved in the directory specified by `paths["results"]` in the local `config.json`, inside a subfolder named after the `folder_name` argument.
- **Recommended Practice**: Since `p_value` is not automatically added to filenames, you should include it in the `folder_name` (e.g., `integrated_p0.5`) to keep runs with different parameters organized.

### Configuration (`config.json`)

The models use parameters from the `config.json` files:

#### Paths (`paths`)
- `results`: Directory for output files (defined in `src/models/integrated/config.json`).
- `beneficiaries`: Path to the active beneficiaries CSV.
- `routes`: Path to the route matrix CSV.
- `dates`: Path to the calendar dates CSV.
- `calendars`: Path to the mandatory calendars CSV.

#### Parameters (`parameters`)
- `total_beneficiaries`: Total number of beneficiaries.
- `total_water_sources`: Total number of water sources.
- `num_candidates`: Number of closest water sources considered for each beneficiary.
- `window_size`: Size of the rolling window (in days).
- `overlap`: Overlap between consecutive windows.
- `use_warm_start`: Boolean to enable loading previous window results as a starting point.
- `mip_gap`: Optimality gap tolerance.
- `threads`: Number of CPU threads for the solver.
- `p_value`: Weighting factor (0.0 to 1.0) in the objective function. A higher value prioritizes reducing the maximum daily peak of trucks, while a lower value prioritizes minimizing transportation costs.

## Glossary of Variables

### Model Parameters
- `NUM_CANDIDATOS`: Number of closest water sources considered for each beneficiary.
- `window_size`: Size of the rolling window (in days).
- `overlap`: Overlap between consecutive windows.
- `p_value`: Weighting factor balancing peak minimization vs. transportation costs.

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

### Execução e Saída

Os modelos integrados podem ser executados via Julia:
```bash
julia integrated_full_model.jl [p_value] [nome_pasta]
julia integrated_rolling_window.jl [p_value] [nome_pasta]
```

- **Formato de Saída**: Arquivos CSV.
- **Nomenclatura**:
  - `abastecimento_$sufixo.csv`: Cronograma de entregas para o período.
  - `alocacao_$sufixo.csv`: Atribuição de fontes aos beneficiários.
  - `$sufixo` corresponde aos tempos de checkpoint (ex: `3h`) ou `melhor_absoluto`.
  - `volumes_todos_dias.csv`: (Apenas Janela Deslizante) Volumes consolidados das cisternas para todo o horizonte.
- **Localização**: Salvos no diretório especificado por `paths["results"]` no `config.json` local, dentro de uma subpasta com o nome definido no argumento `nome_pasta`.
- **Prática Recomendada**: Como o `p_value` não é adicionado automaticamente aos nomes dos arquivos, você deve incluí-lo no `nome_pasta` (ex: `integrado_p0.5`) para manter as execuções com diferentes parâmetros organizadas.

### Configuração (`config.json`)

Os modelos utilizam parâmetros dos arquivos `config.json`:

#### Caminhos (`paths`)
- `results`: Diretório para arquivos de saída (definido em `src/models/integrated/config.json`).
- `beneficiaries`: Caminho para o CSV de beneficiários ativos.
- `routes`: Caminho para o CSV da matriz de rotas.
- `dates`: Caminho para o CSV de datas do calendário.
- `calendars`: Caminho para o CSV de calendários obrigatórios.

#### Parâmetros (`parameters`)
- `total_beneficiaries`: Número total de beneficiários.
- `total_water_sources`: Número total de mananciais.
- `num_candidates`: Número de mananciais mais próximos considerados para cada beneficiário.
- `window_size`: Tamanho da janela deslizante (em dias).
- `overlap`: Sobreposição entre janelas consecutivas.
- `use_warm_start`: Booleano para ativar o carregamento de resultados da janela anterior como ponto de partida.
- `mip_gap`: Tolerância de gap de otimalidade.
- `threads`: Número de threads de CPU para o solver.
- `p_value`: Fator de ponderação (0,0 a 1,0) na função objetivo. Um valor mais alto prioriza a redução do pico máximo diário de caminhões, enquanto um valor mais baixo prioriza a minimização dos custos de transporte.

## Glossário de Variáveis

### Parâmetros do Modelo
- `NUM_CANDIDATOS`: Número de mananciais mais próximos considerados para cada beneficiário.
- `window_size`: Tamanho da janela deslizante (em dias).
- `overlap`: Sobreposição entre janelas consecutivas.
- `p_value`: Fator de ponderação equilibrando a minimização de picos vs. custos de transporte.

### Variáveis de Decisão
- `z[j, i]`: Binária; 1 se o beneficiário `j` for alocado ao manancial `i`.
- `x[j, i, k]`: Inteira; caminhões do manancial `i` para o beneficiário `j` no dia `k`.
- `y_pico`: Pico máximo diário de caminhões.
