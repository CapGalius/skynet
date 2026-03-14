#!/usr/bin/env bash
set -euo pipefail

BASE="/home/capgalius/skynet"
RUN_MODEL="$BASE/run_model.sh"
DETECT="$BASE/ia/detect_models.sh"

clear_screen() { printf '\033c'; }

show_header() {
  clear_screen
  echo "========================================"
  echo "             SKYNET TERMINAL"
  echo "========================================"
}

show_menu() {
  show_header
  echo " MENU PRINCIPAL"
  echo
  echo " 1) Escolha o perfil"
  echo " 2) Modelos detectados"
  echo " 0) Sair"
  echo
  printf "Escolha > "
}

show_profiles() {
  clear_screen
  echo "=== Modelos instalados ==="
  echo
  # Lista numerada conforme solicitado
  echo "1) codellama:7b — programação"
  echo "2) deepseek-coder:6.7b — programação assistida"
  echo "3) llama3:8b — conversas"
  echo "4) qwen2:7b — conversação e multiuso"
  echo
  read -rp "Número do perfil (0 para voltar): " choice || choice=0

  if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ne 0 ]; then
    if [ -x "$RUN_MODEL" ]; then
      echo
      echo "Aplicando perfil $choice..."
      "$RUN_MODEL" "$choice"
      echo
      read -rp "Execução finalizada. Pressione ENTER para limpar a tela e voltar..." _
      clear_screen
    else
      echo
      echo "run_model.sh não encontrado."
      read -rp "Pressione ENTER para voltar..." _
      clear_screen
    fi
  else
    clear_screen
  fi
}

show_detected() {
  clear_screen
  echo "=== Modelos detectados ==="
  echo
  if [ -x "$DETECT" ]; then
    "$DETECT"
  else
    echo "(Script detect_models.sh não encontrado)"
  fi
  echo
  read -rp "Pressione ENTER para voltar..." _
  clear_screen
}

while true; do
  show_menu
  read -r opt || opt=0
  case "$opt" in
    1) show_profiles ;;
    2) show_detected ;;
    0|q|Q) clear_screen; exit 0 ;;
    *) echo; echo "Opção inválida."; sleep 1; clear_screen ;;
  esac
done
