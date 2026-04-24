# Utils / Utilitários

Shared utility functions for the project.
Funções utilitárias compartilhadas para o projeto.

## Configuration Loader / Carregador de Configurações (`config_loader.py` & `config_loader.jl`)

These scripts provide functions to load and merge configuration parameters from both a global `config.json` (at the project root) and a local `config.json` (within the module directory).
Estes scripts fornecem funções para carregar e mesclar parâmetros de configuração tanto de um `config.json` global (na raiz do projeto) quanto de um `config.json` local (dentro do diretório do módulo).

### Key Features / Principais Características
- **Merging**: Local parameters override global ones. / Parâmetros locais substituem os globais.
- **Path Handling**: Automatically converts relative paths in the configuration to absolute paths based on the project root. / Converte automaticamente caminhos relativos na configuração em caminhos absolutos baseados na raiz do projeto.
