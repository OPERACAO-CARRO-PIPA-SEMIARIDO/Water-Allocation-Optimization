# Utils

Shared utility functions for the project.

## Configuration Loader (`config_loader.py` & `config_loader.jl`)

These scripts provide functions to load and merge configuration parameters from both a global `config.json` (at the project root) and a local `config.json` (within the module directory).

### Key Features
- **Merging**: Local parameters override global ones.
- **Path Handling**: Automatically converts relative paths in the configuration to absolute paths based on the project root.

---

# Utilitários

Funções utilitárias compartilhadas para o projeto.

## Carregador de Configurações (`config_loader.py` & `config_loader.jl`)

Estes scripts fornecem funções para carregar e mesclar parâmetros de configuração tanto de um `config.json` global (na raiz do projeto) quanto de um `config.json` local (dentro do diretório do módulo).

### Principais Características
- **Mesclagem**: Parâmetros locais substituem os globais.
- **Tratamento de Caminhos**: Converte automaticamente caminhos relativos na configuração em caminhos absolutos baseados na raiz do projeto.
