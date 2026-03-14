#!/usr/bin/env bash
set -euo pipefail

CONFIG="/home/capgalius/skynet/ia/config"
[ -f "$CONFIG" ] && source "$CONFIG" || true

# carregar descrições em um array associativo (se MODEL_DESCRIPTIONS existir no config)
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

# tenta API local primeiro (silenciosa), depois fallback para 'ollama list'
ids=()
if command -v curl >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
  json=$(curl -sS --max-time 3 http://127.0.0.1:11434/v1/models 2>/dev/null || true)
  if [ -n "$json" ]; then
    mapfile -t ids < <(echo "$json" | jq -r '.data[].id' 2>/dev/null || true)
  fi
fi

if [ ${#ids[@]} -eq 0 ] && command -v ollama >/dev/null 2>&1; then
  # tenta extrair IDs do output humano de 'ollama list'
  mapfile -t ids < <(ollama list 2>/dev/null | awk '/:/{print $1}' | sed 's/,$//' )
fi

if [ ${#ids[@]} -eq 0 ]; then
  echo "Nenhum modelo encontrado."
  exit 0
fi

echo "Modelos instalados:"
for id in "${ids[@]}"; do
  desc="${DESC[$id]:-sem descrição}"
  printf " - %s — %s\n" "$id" "$desc"
done
