# Supply Scheduling Models

This directory contains models to optimize the timing of water deliveries to minimize daily peaks.

## Peak Minimization (`peak_minimization.jl`)

This model decides which day each beneficiary should receive water, considering their consumption rate and tank capacity, to flatten the demand for water trucks.

### Execution and Output

The model can be executed via Julia:
```bash
julia peak_minimization.jl [p_value] [folder_name] [warm_start_file]
```

- **Output Format**: CSV files.
- **Output Naming**: 
  - `abastecimento_$sufixo.csv`: Contains the delivery schedule. `$sufixo` corresponds to the checkpoint time (e.g., `3h`, `6h`) or `melhor_absoluto` for the best found solution.
  - Files are saved in the directory specified by `paths["results"]` in `config.json`, inside a subfolder named after the `folder_name` argument.
  - **Recommended Practice**: Since `p_value` is not automatically added to filenames, you should include it in the `folder_name` (e.g., `results_p0.1`) to keep runs with different parameters organized.

### Configuration (`config.json`)

The model uses parameters from both the global and local `config.json`.

#### Paths (`paths`)
- `results`: Base directory for output files.
- `beneficiaries`: Path to the active beneficiaries CSV.
- `dates`: Path to the calendar dates CSV.
- `calendars`: Path to the mandatory calendars CSV.
- `warm_start_file`: (Optional) Path to a previous solution to accelerate optimization.

#### Parameters (`parameters`)
- `total_beneficiaries`: Number of beneficiaries to consider.
- `total_days`: Number of days in the planning horizon.
- `p_value`: Objective weight (0 to 1) balancing peak reduction (higher `p`) vs. total deliveries (lower `p`).
- `mip_gap`: Optimality gap tolerance (e.g., `0.002` for 0.2%).
- `threads`: Number of CPU threads for the solver.
- `time_checkpoints_hours`: List of hours at which to save intermediate results (e.g., `[3, 6, 9, 12, 15, 18, 21, 24]`).
- `use_warm_start`: Boolean to enable/disable loading the `warm_start_file`.

## Glossary of Variables

### Model Parameters
- `U[j]`: Daily water consumption of beneficiary `j`.
- `C[j]`: Storage capacity of beneficiary `j`.
- `qtd_dias_uteis`: Total number of available delivery days.
- `p_value`: Weighting factor (0.0 to 1.0) in the objective function. A higher value prioritizes reducing the maximum daily peak of trucks, while a lower value prioritizes minimizing the total number of truckloads delivered over the horizon.

### Decision Variables
- `x[j, k]`: Number of truckloads delivered to beneficiary `j` on day `k`.
- `V[j, k]`: Volume of water in tank `j` at the end of day `k`.
- `y`: Maximum daily peak of trucks.

---

# Modelos de Agendamento de Abastecimento

Este diretório contém modelos para otimizar o cronograma de entregas de água para minimizar picos diários.

## Minimização de Picos (`peak_minimization.jl`)

Este modelo decide em qual dia cada beneficiário deve receber água, considerando sua taxa de consumo e capacidade da cisterna, para nivelar a demanda por caminhões-pipa.

### Execução e Saída

O modelo pode ser executado via Julia:
```bash
julia peak_minimization.jl [p_value] [nome_pasta] [arquivo_warm_start]
```

- **Formato de Saída**: Arquivos CSV.
- **Nomenclatura**:
  - `abastecimento_$sufixo.csv`: Contém o cronograma de entregas. `$sufixo` corresponde ao tempo de checkpoint (ex: `3h`, `6h`) ou `melhor_absoluto` para a melhor solução encontrada.
  - Os arquivos são salvos no diretório especificado por `paths["results"]` no `config.json`, dentro de uma subpasta com o nome definido no argumento `nome_pasta`.
  - **Prática Recomendada**: Como o `p_value` não é adicionado automaticamente aos nomes dos arquivos, você deve incluí-lo no `nome_pasta` (ex: `resultados_p0.1`) para manter as execuções com diferentes parâmetros organizadas.

### Configuração (`config.json`)

O modelo utiliza parâmetros do `config.json` global e local.

#### Caminhos (`paths`)
- `results`: Diretório base para os arquivos de saída.
- `beneficiaries`: Caminho para o CSV de beneficiários ativos.
- `dates`: Caminho para o CSV de datas do calendário.
- `calendars`: Caminho para o CSV de calendários obrigatórios.
- `warm_start_file`: (Opcional) Caminho para uma solução anterior para acelerar a otimização.

#### Parâmetros (`parameters`)
- `total_beneficiaries`: Número de beneficiários a considerar.
- `total_days`: Número de dias no horizonte de planejamento.
- `p_value`: Peso no objetivo (0 a 1) equilibrando redução de picos (maior `p`) vs. total de entregas (menor `p`).
- `mip_gap`: Tolerância de gap de otimalidade (ex: `0.002` para 0,2%).
- `threads`: Número de threads de CPU para o solver.
- `time_checkpoints_hours`: Lista de horas em que os resultados intermediários serão salvos (ex: `[3, 6, 9, 12, 15, 18, 21, 24]`).
- `use_warm_start`: Booleano para ativar/desativar o carregamento do `warm_start_file`.

## Glossário de Variáveis

### Parâmetros do Modelo
- `U[j]`: Consumo diário de água do beneficiário `j`.
- `C[j]`: Capacidade de armazenamento do beneficiário `j`.
- `qtd_dias_uteis`: Número total de dias úteis para entrega.
- `p_value`: Fator de ponderação (0,0 a 1,0) na função objetivo. Um valor mais alto prioriza a redução do pico máximo diário de caminhões, enquanto um valor mais baixo prioriza a minimização do número total de carradas entregues no horizonte.

### Variáveis de Decisão
- `x[j, k]`: Número de caminhões entregues ao beneficiário `j` no dia `k`.
- `V[j, k]`: Volume de água na cisterna `j` ao final do dia `k`.
- `y`: Pico máximo diário de caminhões.
