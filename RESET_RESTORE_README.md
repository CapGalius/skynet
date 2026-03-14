# Script de Reset e Restauração Completa do Sistema

## 📋 O que o script faz

Este script automatiza todo o processo de reset e restauração do seu sistema Ubuntu com o ambiente Skynet. Ele:

1. **📊 Detecta modelos LLM** instalados via Ollama
2. **💾 Faz backup** de arquivos importantes (SSH, Git config)
3. **🧹 Limpa** dependências antigas (Python, Node, Ollama)
4. **⬇️ Reinstala** todas as dependências do sistema
5. **🦙 Reinstala** Ollama
6. **📦 Baixa** skynet novamente do GitHub
7. **🤖 Reinstala** modelos LLM salvos
8. **👨‍💻 Reinstala** Copilot CLI

## 🚀 Como usar

### Opção 1: Script Interativo (Recomendado)

```bash
cd ~/skynet
./reset_and_restore.sh
```

O script vai fazer perguntas para cada etapa, permitindo que você escolha o que fazer.

### Opção 2: Script Automático (Completo)

```bash
cd ~/skynet
bash -c "source ./reset_and_restore.sh; main"
```

## ⚠️ Avisos Importantes

- **FAÇA BACKUP**: O script faz backup automático em `~/.skynet_backup_YYYYMMDD_HHMMSS/`
- **Requer sudo**: Algumas operações precisam de permissões de administrador
- **Tempo**: Todo o processo pode levar 30-60 minutos dependendo dos modelos
- **Conexão**: Certifique-se de ter uma conexão estável com a internet
- **Espaço**: Ollama + modelos podem usar 5-50 GB de espaço em disco

## 📂 Estrutura de Backup

Após a execução, você terá:

```
~/.skynet_backup_20260314_031629/
├── models_list.txt          # Lista de modelos instalados
├── git_config/              # Backup do .git
├── ssh_backup/              # Backup de chaves SSH
└── gitconfig_backup         # Backup do Git config
```

## 🔧 Dependências Instaladas

O script instala automaticamente:

### Sistema
- `build-essential` - Compiladores e ferramentas de desenvolvimento
- `curl`, `wget` - Download de arquivos
- `git` - Controle de versão
- `jq` - Parser JSON
- `python3`, `python3-pip`, `python3-dev` - Python
- `nodejs`, `npm` - Node.js
- `bash`, `zsh` - Shells

### Aplicações
- **Ollama** - Servidor de modelos LLM locais
- **Copilot CLI** - GitHub Copilot Command Line
- **Skynet** - Seu projeto clonado do GitHub

## 📊 Modelos LLM Detectados

O script usa o `detect_models.sh` da pasta `ia/` para encontrar modelos instalados:

```bash
~/skynet/ia/detect_models.sh
```

Exemplos de modelos que podem ser detectados:
- `llama2`
- `mistral`
- `neural-chat`
- `zephyr`
- Qualquer outro modelo Ollama instalado

## ✅ Verificação Final

Ao final, o script mostra o status de:
- Git
- Python3
- Node/NPM
- Ollama
- Curl
- JQ
- Skynet (pasta)
- Modelos Ollama instalados

## 🛠️ Troubleshooting

### Ollama não inicia
```bash
sudo systemctl start ollama
sudo systemctl status ollama
```

### Verificar modelos instalados
```bash
ollama list
```

### Puxar um modelo manualmente
```bash
ollama pull llama2
```

### Remover um modelo
```bash
ollama rm llama2
```

### Limpar cache do Ollama
```bash
rm -rf ~/.ollama/models
```

## 📝 Exemplo de Uso Completo

```bash
# 1. Ir para a pasta skynet
cd ~/skynet

# 2. Executar o script
./reset_and_restore.sh

# 3. Responder as perguntas (recomendado: responder 's' para tudo na primeira vez)

# 4. Aguardar conclusão (pode levar 30-60 minutos)

# 5. Verificar o resultado
ollama list
ls -la ~/skynet/ia/
```

## 🔐 Segurança

- O script mantém backups de suas chaves SSH
- Git config é preservado
- Senhas não são armazenadas
- Use seu token/credentials conforme necessário após restauração

## 📞 Suporte

Se encontrar problemas:
1. Verifique os logs em `~/.skynet_backup_*/`
2. Rode `./ia/detect_models.sh` para verificar modelos
3. Verifique conexão de internet
4. Tente etapas individuais em vez do script completo

## 🎯 Próximos Passos

Após o reset:

1. Configure seu Git novamente:
```bash
git config --global user.name "Seu Nome"
git config --global user.email "seu@email.com"
```

2. Teste um modelo:
```bash
ollama run llama2
```

3. Inicie o programa Skynet:
```bash
cd ~/skynet
./menu.sh
```

---

**Versão do Script:** 1.0.0  
**Última Atualização:** 2026-03-14  
**Compatível com:** Ubuntu 20.04+
