# 🔰 MATRIX AI CONSOLE - 80s RETRO EDITION

Interface offline para gerenciar e executar modelos de IA local usando **Ollama**.

## Visão Geral

**Matrix AI Console** é um programa retro dos anos 80 com estilo cyberpunk (cores Matrix) que oferece uma interface completa para gerenciar e executar modelos de inteligência artificial offline localmente.

### Características

✨ **Visuais Retro 80s**
- Cores estilo Matrix (verde brilhante)
- ASCII art e bordas decorativas
- Interface nostálgica com ícones [●] e [>]

🚀 **Funcionalidades**
- Listar modelos instalados
- Visualizar perfis configurados
- Executar modelos de forma interativa
- Status do sistema em tempo real
- Suporte a múltiplos modelos de IA

⚙️ **Suporte**
- Modelos: CodeLlama, DeepSeek Coder, Llama 3, Qwen 2
- Execução com GPU ativada por padrão
- Sem dependências de internet (100% offline)

---

## Instalação

### Pré-requisitos

- **Ollama** instalado: https://ollama.ai
- **Python 3.7+** (opcional, para UI avançada)
- **curl** e **jq** (para detecção de modelos)

### Setup

```bash
# 1. Clonar/atualizar permissões
chmod +x /home/capgalius/skynet/ia/matrix_ai.sh
chmod +x /home/capgalius/skynet/ia/matrix_ai.py

# 2. Criar atalho (opcional)
sudo ln -s /home/capgalius/skynet/ia/matrix_ai.sh /usr/local/bin/matrix-ai
```

---

## Uso

### Shell Script (Recomendado)

```bash
# Menu interativo
./matrix_ai.sh

# Comandos rápidos
./matrix_ai.sh models      # Listar modelos
./matrix_ai.sh profiles    # Listar perfis
./matrix_ai.sh status      # Status do sistema
./matrix_ai.sh ui          # Iniciar UI Python avançada
```

### Python UI (Avançada)

```bash
python3 /home/capgalius/skynet/ia/matrix_ai.py
```

---

## Configuração

Edite `/home/capgalius/skynet/ia/config`:

```bash
# Modelos disponíveis
CODELLAMA="codellama:7b"
DEEPSEEK="deepseek-coder:6.7b"
LLAMA8B="llama3:8b"
QWEN="qwen2:7b"

# Perfis (para casos de uso específicos)
PROFILE_programming="DEEPSEEK CODELLAMA QWEN"
PROFILE_study="LLAMA8B QWEN"
PROFILE_conversation="LLAMA8B QWEN"

# Descrições dos modelos
MODEL_DESCRIPTIONS=$'codellama:7b=programação\n\
deepseek-coder:6.7b=programação assistida\n\
...'
```

---

## Menu Principal

```
[1] List Models          - Mostra todos os modelos instalados
[2] List Profiles        - Exibe os perfis configurados
[3] Select & Run Model   - Seleção interativa com funções e execução
[4] System Status        - Status da conexão e modelos
[5] Python UI (Advanced) - Interface avançada em Python
[6] GitHub Copilot CLI   - Acesso direto ao Copilot
[7] Clear Screen         - Limpa a tela
[0] Exit                 - Sair do programa
```

---

## Exemplos de Uso

### Listar todos os modelos

```bash
./matrix_ai.sh models
```

Output:
```
╔════ AVAILABLE MODELS ════╗

[●] 1. codellama:7b
    └─ programação
[●] 2. deepseek-coder:6.7b
    └─ programação assistida
```

### Iniciar um modelo

```bash
./matrix_ai.sh
# Selecione opção 3 → Escolha o modelo (com descrição de função)
```

Cada modelo agora exibe sua função ao selecionar:
```
[1] codellama:7b
    └─ programação
[2] deepseek-coder:6.7b
    └─ programação assistida
```

### Executar Python UI

```bash
./matrix_ai.sh ui
# ou
python3 matrix_ai.py
```

---

## Estrutura de Arquivos

```
/home/capgalius/skynet/ia/
├── config                  # Configuração de modelos e perfis
├── matrix_ai.sh           # Script shell principal
├── matrix_ai.py           # UI Python avançada
├── detect_models.sh       # Detectar modelos instalados
├── menu.sh                # Menu original
├── sessions.log           # Log de sessões
└── README.md              # Este arquivo
```

---

## Atalhos de Teclado

| Tecla | Ação |
|-------|------|
| Ctrl+C | Parar modelo em execução |
| Enter | Continuar / Confirmar |
| 0 | Voltar / Sair |

---

## GitHub Copilot Integration

O Matrix AI Console agora inclui acesso direto ao **GitHub Copilot CLI**!

### Uso

No menu principal, selecione:
```
[6] GitHub Copilot CLI
```

Isso abrirá o Copilot em modo interativo dentro da aplicação.

### Instalação do Copilot

Se você ainda não tem o Copilot instalado:

```bash
# 1. Instalar a extensão gh-copilot
gh extension install github/gh-copilot

# 2. Autenticar
gh auth login

# 3. Usar via CLI
copilot
```

### Exemplos de Uso

```bash
# Obter sugestões de código
copilot suggest "função para ler arquivo JSON"

# Explicar código
copilot explain "função complexa"

# Gerar testes
copilot suggest "teste unitário para"
```

---

### "Ollama service is OFFLINE"

```bash
# Inicie o servidor Ollama em outro terminal
ollama serve
```

### "No models found"

```bash
# Baixe um modelo
ollama pull codellama:7b
ollama pull deepseek-coder:6.7b
```

### Permissão negada

```bash
chmod +x /home/capgalius/skynet/ia/matrix_ai.sh
chmod +x /home/capgalius/skynet/ia/matrix_ai.py
```

---

## Modelos Recomendados

| Modelo | Tamanho | Caso de Uso |
|--------|---------|------------|
| codellama:7b | 3.7GB | Geração de código |
| deepseek-coder:6.7b | 3.8GB | Assistente de programação |
| llama3:8b | 4.7GB | Conversação geral |
| qwen2:7b | 4.4GB | Multiuso e conversação |

---

## Logs

Todas as ações são registradas em:
```
/home/capgalius/skynet/ia/sessions.log
```

---

## Suporte

Para adicionar novos modelos ou perfis, edite o arquivo `config` e reinicie o programa.

---

**Desenvolvido com ❤️ em Bash e Python**
