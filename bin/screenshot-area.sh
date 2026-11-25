#!/bin/sh
# ~/.local/bin/screenshot-area.sh — Capture d'écran par sélection (Win + Maj + S)
set -eu

TARGET_DIR="$HOME/Images/Screenshots"
mkdir -p "$TARGET_DIR"
FILENAME="$TARGET_DIR/Capture_$(date '+%Y-%m-%d_%H-%M-%S').png"

# Capture interactive avec bordure Catppuccin
if maim -s -u -b 2 -c 0.8,0.65,0.97,0.4 "$FILENAME" 2>/dev/null; then
    if [ -s "$FILENAME" ]; then
        # Image dans CLIPBOARD (pour GIMP, navigateurs, etc.)
        xclip -selection clipboard -t image/png -i "$FILENAME"
        # Chemin dans PRIMARY (clic molette / Shift+Insert dans les terminaux)
        printf '%s\n' "$FILENAME" | xclip -selection primary
        if command -v notify-send >/dev/null 2>&1; then
            notify-send -i "$FILENAME" "Capture d'écran" "Image copiée, chemin en sélection primaire : $FILENAME"
        fi
    fi
fi
