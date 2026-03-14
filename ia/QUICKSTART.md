# 🔰 MATRIX AI - QUICK START

## Executar o Programa

```bash
cd /home/capgalius/skynet/ia
./matrix_ai.sh
```

## Comandos Rápidos

```bash
# Menu interativo
./matrix_ai.sh

# Listar modelos disponíveis
./matrix_ai.sh models

# Ver perfis configurados
./matrix_ai.sh profiles

# Status do sistema
./matrix_ai.sh status

# Interface Python avançada
./matrix_ai.sh ui
```

## Menu Interativo

```
[1] List Models          - Mostra modelos instalados
[2] List Profiles        - Exibe perfis (programming, study, conversation)
[3] Select & Run Model   - Seleciona e executa um modelo
[4] System Status        - Verifica conexão e modelos
[5] Python UI (Advanced) - Interface Python retro
[6] GitHub Copilot CLI   - Acesso ao Copilot
[7] Clear Screen         - Limpa tela
[0] Exit                 - Sair
```

## Atalho do Sistema (Opcional)

```bash
sudo ln -s /home/capgalius/skynet/ia/matrix_ai.sh /usr/local/bin/matrix-ai
# Depois use: matrix-ai
```

## Troubleshooting

### Ollama está offline?
```bash
# Em outro terminal, inicie o servidor
ollama serve
```

### Nenhum modelo encontrado?
```bash
# Baixe um modelo
ollama pull codellama:7b
ollama pull deepseek-coder:6.7b
ollama pull llama3:8b
ollama pull qwen2:7b
```

### Permissão negada?
```bash
chmod +x /home/capgalius/skynet/ia/matrix_ai.sh
chmod +x /home/capgalius/skynet/ia/matrix_ai.py
```

## Modelos Disponíveis

- **codellama:7b** - Programação (3.7GB)
- **deepseek-coder:6.7b** - Assistente de código (3.8GB)
- **llama3:8b** - Conversação geral (4.7GB)
- **qwen2:7b** - Multiuso (4.4GB)

## Configuração

Edite `/home/capgalius/skynet/ia/config` para:
- Adicionar novos modelos
- Criar novos perfis
- Modificar descrições

## GitHub Copilot Integration

Use a opção [6] no menu para acessar o GitHub Copilot CLI diretamente!

### Instalar Copilot

```bash
gh extension install github/gh-copilot
```

---

**🎮 Aproveite a experiência retro 80s com IA offline!**
