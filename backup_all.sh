#!/usr/bin/env bash

SOURCE_DIR="$HOME/.config"
TARGET_DIR="./config"
DIRECTORIES=("hypr" "waybar" "rofi" "swaync" "wallust" "wlogout" "fastfetch" "kitty")

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}[INFO]${NC} Inizio sincronizzazione dotfiles..."

if [ ! -d "$SOURCE_DIR" ]; then
  echo -e "${RED}[ERROR]${NC} Sorgente $SOURCE_DIR non trovata."
  exit 1
fi

mkdir -p "$TARGET_DIR"

for dir in "${DIRECTORIES[@]}"; do
  if [ -d "$SOURCE_DIR/$dir" ]; then
    echo -e "${BLUE}[SYNC]${NC} Copia di: $dir..."

    rsync -av --delete "$SOURCE_DIR/$dir/" "$TARGET_DIR/$dir/" >/dev/null
  else
    echo -e "${RED}[WARN]${NC} Directory $dir non trovata in $SOURCE_DIR. Salto."
  fi
done

echo -e "${GREEN}[SUCCESS]${NC} Backup completato in $TARGET_DIR."
