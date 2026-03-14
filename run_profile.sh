#!/usr/bin/env bash
set -euo pipefail
BASE="/home/capgalius/skynet"
CONFIG="$BASE/ia/config"
[ -f "$CONFIG" ] && source "$CONFIG" || true

resolve_model(){ printf "%s" "${!1:-}"; }
expand_profile(){
  local pv="$1"; local names="${!pv:-}"; local out=""
  for n in $names; do out="$out$(resolve_model "$n") "; done
  echo "${out%" "}"
}

PROFILE="${1:-${DEFAULT_PROFILE:-programming}}"
MODELS="$(expand_profile "PROFILE_${PROFILE}")"
[ -z "$MODELS" ] && { echo "Perfil vazio."; exit 0; }

read -r -a ARR <<< "$MODELS"
echo "Modelos do perfil $PROFILE:"
for i in "${!ARR[@]}"; do printf "%2d) %s\n" $((i+1)) "${ARR[$i]}"; done
printf "%2d) %s\n" 0 "Voltar ao menu"

while true; do
  read -rp "Número do modelo: " c
  [[ "$c" =~ ^[0-9]+$ ]] || { echo "Inválido."; continue; }
  [ "$c" -eq 0 ] && exit 0
  idx=$((c-1))
  [ $idx -ge 0 -a $idx -lt ${#ARR[@]} ] || { echo "Fora do intervalo."; continue; }
  MODEL="${ARR[$idx]}"
  echo "Abrindo REPL: $MODEL"
  OLLAMA_CMD="${OLLAMA_CMD:-ollama run}"
  eval $OLLAMA_CMD "\"$MODEL\""
  echo "REPL de $MODEL encerrado. Retornando ao menu."
  exit 0
done
