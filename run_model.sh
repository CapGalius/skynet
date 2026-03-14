#!/usr/bin/env bash
set -euo pipefail

CONFIG="/home/capgalius/skynet/ia/config"
[ -f "$CONFIG" ] && source "$CONFIG" || true

# carregar descrições em um array associativo
declare -A DESC
if [ -n "${MODEL_DESCRIPTIONS:-}" ]; then
  while IFS='=' read -r key val; do
    key="${key#"${key%%[![:space:]]*}"}"
    key="${key%"${key##*[![:space:]]}"}"
    val="${val#"${val%%[![:space:]]*}"}"
    val="${val%"${val##*[![:space:]]}"}"
    [ -n "$key" ] && DESC["$key"]="$val"
  done <<< "$MODEL_DESCRIPTIONS"
fi

# obter lista de modelos via API ou fallback para ollama list
models_json=""
if command -v curl >/dev/null 2>&1; then
  models_json=$(curl -sS --max-time 3 http://127.0.0.1:11434/v1/models 2>/dev/null || true)
fi

mapfile -t ids < <(echo "$models_json" | jq -r '.data[].id' 2>/dev/null || true)

if [ ${#ids[@]} -eq 0 ]; then
  if command -v ollama >/dev/null 2>&1; then
    mapfile -t ids < <(ollama list 2>/dev/null | awk '/:/{print $1}' | sed 's/,$//' )
  fi
fi

if [ ${#ids[@]} -eq 0 ]; then
  echo "Nenhum modelo encontrado via API ou 'ollama list'."
  exit 0
fi

echo
echo "Modelos instalados (escolha por número):"
for i in "${!ids[@]}"; do
  id="${ids[$i]}"
  desc="${DESC[$id]:-sem descrição}"
  printf "%2d) %s — %s\n" $((i+1)) "$id" "$desc"
done
printf "%2d) %s\n" 0 "Voltar ao menu"

# escolha
while true; do
  read -rp "Número do modelo: " choice
  if ! [[ "$choice" =~ ^[0-9]+$ ]]; then
    echo "Entrada inválida."
    continue
  fi
  if [ "$choice" -eq 0 ]; then
    echo "Retornando ao menu..."
    exit 0
  fi
  index=$((choice-1))
  if [ "$index" -lt 0 ] || [ "$index" -ge "${#ids[@]}" ]; then
    echo "Número fora do intervalo."
    continue
  fi
  break
done

MODEL_ID="${ids[$index]}"
MODEL_DESC="${DESC[$MODEL_ID]:-sem descrição}"
echo
echo "Abrindo REPL do modelo selecionado: $MODEL_ID — $MODEL_DESC"
OLLAMA_CMD="${OLLAMA_CMD:-ollama run}"

# abre REPL diretamente (sem perguntar por prompt)
eval $OLLAMA_CMD "\"$MODEL_ID\""

echo
echo "REPL de $MODEL_ID encerrado. Retornando ao menu."
