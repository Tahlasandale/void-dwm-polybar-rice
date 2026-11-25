#!/bin/sh
# Bascule la palette Polybar entre dark et eink, puis relance les barres.
cd "$HOME/.config/polybar" || exit 1

CURRENT=$(readlink colors.ini 2>/dev/null || printf '')
case "$CURRENT" in
    themes/eink.ini) TARGET=themes/dark.ini ;;
    *)               TARGET=themes/eink.ini ;;
esac

ln -sfn "$TARGET" colors.ini
pkill -x polybar 2>/dev/null || true
sleep 0.3
exec "$HOME/.config/polybar/launch.sh"
