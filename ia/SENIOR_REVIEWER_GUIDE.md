# 🔰 SENIOR CODE REVIEWER AGENT

**Programador Sênior com 15+ Anos de Experiência**

Agente que combina modelos offline e online para gerar e revisar código como um desenvolvedor experiente.

## Visão Geral

### Fluxo de Trabalho

```
┌─────────────────────────────────────┐
│   Descrição da Tarefa               │
└────────────┬────────────────────────┘
             ↓
┌─────────────────────────────────────┐
│   STEP 1: Gerar Código (Offline)    │
│   • CodeLlama / DeepSeek / Llama 3  │
│   • Modelo offline (privado)        │
│   • Execução rápida com GPU         │
└────────────┬────────────────────────┘
             ↓
┌─────────────────────────────────────┐
│   STEP 2: Revisar (Online)          │
│   • GitHub Copilot                  │
│   • Análise sênior completa         │
│   • Sugestões de melhoria           │
└────────────┬────────────────────────┘
             ↓
┌─────────────────────────────────────┐
│   Código Gerado + Feedback          │
│   • Pronto para produção            │
│   • Com melhorias aplicadas         │
└─────────────────────────────────────┘
```

## Como Usar

### Menu Interativo (Recomendado)

```bash
cd /home/capgalius/skynet/ia
./senior_code_reviewer.sh
```

Ou com Python:
```bash
python3 senior_code_reviewer.py
```

### Opções do Menu

```
[1] Generate Code (Offline)
    └─ Gera código com modelo offline
    └─ Opção: Python, JavaScript, Go, Rust
    
[2] Review Code File (Copilot)
    └─ Revisa arquivo existente com Copilot
    └─ Análise profissional de sênior
    
[3] Generate & Review (Full Cycle)
    └─ Fluxo completo: gera e depois revisa
    └─ Recomendado para tarefas complexas
    
[4] Check Model Status
    └─ Verifica disponibilidade de modelos
    └─ Status: Ollama + Copilot
    
[5] View Review History
    └─ Histórico de revisões realizadas
    └─ Últimas 20 ações registradas
    
[0] Exit
    └─ Sair da aplicação
```

## Comandos Rápidos

### Shell Script

```bash
# Gerar código
./senior_code_reviewer.sh generate "função para validar email"

# Revisar arquivo
./senior_code_reviewer.sh review /caminho/para/codigo.py

# Ciclo completo
./senior_code_reviewer.sh full "API REST com autenticação JWT"

# Verificar status
./senior_code_reviewer.sh status

# Menu interativo
./senior_code_reviewer.sh
```

### Variáveis de Ambiente

```bash
# Mudar modelo offline (padrão: codellama:7b)
export REVIEW_MODEL=deepseek-coder:6.7b
./senior_code_reviewer.sh generate "sua tarefa"

# Mudar linguagem (padrão: python)
export REVIEW_LANGUAGE=javascript
./senior_code_reviewer.sh generate "sua tarefa"
```

## Perfil do Revisor Sênior

### Experiência
- 15+ anos de desenvolvimento
- Expertise em múltiplas linguagens
- Conhecimento profundo de arquitetura

### Análise Realizada

1. **Code Quality** ⭐⭐⭐⭐⭐
   - Estrutura e organização
   - Clareza e legibilidade
   - Manutenibilidade

2. **Best Practices** ⭐⭐⭐⭐⭐
   - Convenções da linguagem
   - Padrões de design
   - Idiomas específicos

3. **Performance** ⭐⭐⭐⭐⭐
   - Eficiência de algoritmos
   - Uso de memória
   - Oportunidades de otimização

4. **Security** ⭐⭐⭐⭐⭐
   - Vulnerabilidades potenciais
   - Tratamento de erros
   - Validação de entrada

5. **Testing** ⭐⭐⭐⭐⭐
   - Testabilidade do código
   - Cobertura de casos extremos
   - Manutenibilidade de testes

## Modelos Disponíveis

### Offline (Geração)

| Modelo | Tamanho | Velocidade | Qualidade |
|--------|---------|-----------|-----------|
| codellama:7b | 3.7GB | ⚡⚡⚡ | ⭐⭐⭐⭐ |
| deepseek-coder:6.7b | 3.8GB | ⚡⚡⚡ | ⭐⭐⭐⭐⭐ |
| llama3:8b | 4.7GB | ⚡⚡ | ⭐⭐⭐⭐ |
| qwen2:7b | 4.4GB | ⚡⚡⚡ | ⭐⭐⭐⭐ |

### Online (Revisão)

| Modelo | Capacidade | Uso |
|--------|-----------|-----|
| GitHub Copilot CLI | Avançado | Revisão sênior |

## Exemplos de Uso

### Exemplo 1: Gerar Função

```bash
./senior_code_reviewer.sh generate "função para calcular fibonacci com memoização"
```

**Output esperado:**
- Código gerado com Comments
- Tratamento de erros
- Seguindo best practices

### Exemplo 2: Revisar Código

```bash
./senior_code_reviewer.sh review ~/meu_projeto/utils.py
```

**Output esperado:**
- Análise de qualidade
- Sugestões de melhoria
- Avaliação de segurança

### Exemplo 3: Ciclo Completo

```bash
./senior_code_reviewer.sh full "API REST com autenticação e CRUD"
```

**Output esperado:**
1. Código gerado (offline)
2. Revisão do código (online)
3. Sugestões de refatoração

## Logs e Histórico

### Arquivo de Log

```
/home/capgalius/skynet/ia/code_reviews.log
```

Registra todas as ações:
```
[2026-03-12 21:20:45] Code generated: função para ler JSON (Model: codellama:7b)
[2026-03-12 21:21:30] Code reviewed: /home/user/main.py
[2026-03-12 21:22:15] Full cycle completed: API REST com autenticação
```

### Visualizar Histórico

No menu, selecione **[5] View Review History**

## Integração com Matrix AI Console

Você pode chamar o Senior Reviewer diretamente do Matrix AI Console:

```bash
# No menu do Matrix AI
./matrix_ai.sh

# Depois selecione uma opção apropriada
# Ou abra em outro terminal:
./senior_code_reviewer.sh
```

## Requisitos

### Offline (Geração)
- ✅ Ollama instalado
- ✅ Modelos baixados (ollama pull ...)
- ✅ GPU ativada (recomendado)

### Online (Revisão)
- ✅ GitHub CLI (gh)
- ✅ Extensão Copilot (gh extension install github/gh-copilot)
- ✅ Autenticação GitHub (gh auth login)

## Troubleshooting

### "Ollama service is OFFLINE"

```bash
# Em outro terminal:
ollama serve

# Depois use o reviewer
./senior_code_reviewer.sh
```

### "Copilot not available"

```bash
# Instale a extensão
gh extension install github/gh-copilot

# Autentique
gh auth login

# Tente novamente
./senior_code_reviewer.sh
```

### "Model not found"

```bash
# Baixe o modelo desejado
ollama pull deepseek-coder:6.7b
ollama pull codellama:7b

# Verifique modelos disponíveis
./senior_code_reviewer.sh status
```

## Casos de Uso

### 1. Code Review Automático
```bash
./senior_code_reviewer.sh review src/main.py
# Análise completa do arquivo
```

### 2. Geração de Código
```bash
./senior_code_reviewer.sh generate "API com autenticação JWT"
# Código pronto para produção
```

### 3. Aprendizado
```bash
./senior_code_reviewer.sh full "padrão observer em typescript"
# Vê código + feedback de sênior
```

### 4. Refatoração
```bash
./senior_code_reviewer.sh review codigo_legado.py
# Sugestões de modernização
```

## Dicas Profissionais

1. **Use modelos diferentes para linguagens específicas**
   ```bash
   export REVIEW_LANGUAGE=rust
   export REVIEW_MODEL=deepseek-coder:6.7b
   ./senior_code_reviewer.sh generate "sistema de tipos customizado"
   ```

2. **Salve código gerado para revisões posteriores**
   ```bash
   ./senior_code_reviewer.sh generate "sua tarefa" > codigo_gerado.py
   ./senior_code_reviewer.sh review codigo_gerado.py
   ```

3. **Use para aprendizado**
   - Gere código
   - Leia análise do revisor
   - Estude as sugestões
   - Aplique no seu projeto

4. **Combine com controle de versão**
   ```bash
   git diff HEAD~1 > changes.patch
   cat changes.patch | ./senior_code_reviewer.sh
   ```

## Performance

### Tempos Esperados

| Operação | Tempo | Variáveis |
|----------|-------|-----------|
| Geração de código (100 linhas) | 5-15s | Modelo, GPU |
| Revisão com Copilot | 3-10s | Tamanho código |
| Ciclo completo | 15-30s | Complexidade |

### Otimizações

- GPU ativada por padrão (OLLAMA_GPU=1)
- Timeouts configuráveis
- Cache de modelos

## Licença e Créditos

Desenvolvido com ❤️ em Bash e Python
Utiliza:
- Ollama (modelos offline)
- GitHub Copilot CLI (revisão online)

---

**🔰 Pronto para código profissional de qualidade!**
