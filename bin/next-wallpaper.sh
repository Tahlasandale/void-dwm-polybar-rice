#!/bin/sh
# ~/.local/bin/next-wallpaper.sh — cycle des fonds dans ~/Images/wallpapers
set -eu

if [ -z "${DISPLAY:-}" ]; then
    NEWEST_SOCK=$(ls -t /tmp/.X11-unix/X* 2>/dev/null | head -n 1 || true)
    if [ -n "$NEWEST_SOCK" ]; then
        DISP_NUM=$(basename "$NEWEST_SOCK" | sed 's/^X//')
        export DISPLAY=":${DISP_NUM}"
    else
        export DISPLAY=":0"
    fi
fi

WALL_DIR="$HOME/Images/wallpapers"
CACHE_DIR="$HOME/.cache"
CURRENT_FILE="$CACHE_DIR/current-wallpaper"
LOG_FILE="$CACHE_DIR/wallpaper.log"
mkdir -p "$WALL_DIR" "$CACHE_DIR"

WALLPAPERS=$(find "$WALL_DIR" -maxdepth 2 -type f \
    \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' \) \
    2>/dev/null | sort || true)

if [ -z "$WALLPAPERS" ]; then
    printf '%s aucun fond dans %s\n' "$(date '+%F %T')" "$WALL_DIR" >> "$LOG_FILE"
    notify-send -u low -t 3000 "Fond d'écran" "Aucune image dans ~/Images/wallpapers" 2>/dev/null || true
    exit 1
fi

CURRENT=$(cat "$CURRENT_FILE" 2>/dev/null || true)
COUNT=$(printf '%s\n' "$WALLPAPERS" | wc -l)
if [ "$COUNT" -gt 1 ]; then
    NEXT=$(printf '%s\n' "$WALLPAPERS" | grep -vFx "$CURRENT" | shuf -n 1 || true)
    [ -n "$NEXT" ] || NEXT=$(printf '%s\n' "$WALLPAPERS" | shuf -n 1)
else
    NEXT=$(printf '%s\n' "$WALLPAPERS" | head -n 1)
fi

if feh --bg-fill "$NEXT" 2>>"$LOG_FILE"; then
    printf '%s\n' "$NEXT" > "$CURRENT_FILE"
    notify-send -u low -t 2000 "Fond d'écran" "$(basename "$NEXT")" 2>/dev/null || true
else
    notify-send -u low -t 3000 "Fond d'écran" "Échec : voir ~/.cache/wallpaper.log" 2>/dev/null || true
    exit 1
fi
