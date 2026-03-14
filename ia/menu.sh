#!/usr/bin/env bash
set -euo pipefail
BASE="/home/capgalius/skynet"
RETRO="$BASE/retro_ui.sh"
if [ -x "$RETRO" ]; then
  exec "$RETRO"
else
  echo "Interface principal não encontrada: $RETRO"
  exit 1
fi
