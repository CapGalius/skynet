#!/usr/bin/env bash
set -euo pipefail

BASE="/home/capgalius/skynet"
RUN_MODEL="$BASE/run_model.sh"

echo "======================================"
echo "       MENU AVANÇADO DE IAs"
echo " Base: /home/capgalius/skynet"
echo "======================================"
echo "1) Rodar perfil (padrão: programming)"
echo "2) Modelos detectados"
echo "3) Rodar modelo manual"
echo "4) Ver histórico de sessões"
echo "5) Detectar e listar modelos instalados"
echo "0) Sair"
echo "======================================"

read -rp "Escolha: " opt
case "$opt" in
  1)
    cd "$BASE" && ./run_profile.sh programming
    ;;
  2)
    ollama list
    curl -sS http://127.0.0.1:11434/v1/models | jq -C .
    ;;
  3)
    if [ -x "$RUN_MODEL" ]; then
      "$RUN_MODEL"
    else
      echo "Script de execução não encontrado: $RUN_MODEL"
    fi
    ;;
  4)
    ls -lt "$BASE/sessions" 2>/dev/null | head -n 40
    tail -n 200 /home/capgalius/skynet/ia/ollama-serve.log 2>/dev/null || true
    ;;
  5)
    ollama list
    curl -sS http://127.0.0.1:11434/v1/models | jq -C .
    ;;
  0)
    exit 0
    ;;
  *)
    echo "Opção inválida."
    ;;
esac
