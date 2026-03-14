# 🔰 SENIOR CODE REVIEWER - QUICK START

## O que é?

Um agente que combina **IA Offline** (geração) com **GitHub Copilot** (revisão) para atuar como um programador sênior com 15+ anos de experiência.

## Uso Rápido

### Menu Interativo
```bash
cd /home/capgalius/skynet/ia
./senior_code_reviewer.sh
```

### Comandos Rápidos
```bash
# Gerar código
./senior_code_reviewer.sh generate "função para validar email"

# Revisar arquivo
./senior_code_reviewer.sh review ~/code.py

# Ciclo completo (gera + revisa)
./senior_code_reviewer.sh full "API REST com autenticação"

# Ver status dos modelos
./senior_code_reviewer.sh status
```

## Menu Interativo

```
[1] Generate Code (Offline)      ← Usa CodeLlama/DeepSeek
[2] Review Code File (Copilot)   ← Usa GitHub Copilot
[3] Generate & Review (Full)     ← Combina ambos
[4] Check Model Status           ← Verifica disponibilidade
[5] View Review History          ← Histórico de revisões
[0] Exit
```

## Fluxo Padrão (Recomendado)

**Opção [3]: Generate & Review**

1. **STEP 1**: Gera código com modelo offline (rápido)
2. **STEP 2**: Revisa com GitHub Copilot (profissional)
3. **OUTPUT**: Código + feedback sênior

## Requisitos

```bash
# Verificar/instalar
ollama serve                    # Em outro terminal
gh extension install github/gh-copilot
gh auth login
```

## Perfil do Revisor

- **Experiência**: 15+ anos de desenvolvimento
- **Análise**: Code Quality, Best Practices, Performance, Security, Testing
- **Feedback**: Construtivo e profissional

## Exemplos

**Exemplo 1: Gerar função**
```bash
./senior_code_reviewer.sh generate "função fibonacci com cache"
# Gera código otimizado com comentários
```

**Exemplo 2: Revisar código**
```bash
./senior_code_reviewer.sh review src/main.py
# Análise profissional: qualidade, segurança, performance
```

**Exemplo 3: Ciclo completo**
```bash
./senior_code_reviewer.sh full "sistema de autenticação com JWT"
# Gera → Revisa → Retorna código validado
```

## Integração com Matrix AI

```bash
./matrix_ai.sh
# Selecione [6] Senior Code Reviewer
```

## Variáveis de Ambiente

```bash
# Mudar modelo
export REVIEW_MODEL=deepseek-coder:6.7b

# Mudar linguagem
export REVIEW_LANGUAGE=javascript

# Usar
./senior_code_reviewer.sh generate "sua tarefa"
```

## Histórico

```bash
# No menu, selecione [5]
# Ou visualize arquivo:
tail -20 /home/capgalius/skynet/ia/code_reviews.log
```

## Dicas

1. Use **[3] Full Cycle** para tarefas complexas
2. Use **[1] Generate** para ideias rápidas
3. Use **[2] Review** para código legado
4. Consulte histórico para aprender

---

**Pronto! Você tem um sênior para revisar seu código! 🚀**
