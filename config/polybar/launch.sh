#!/bin/sh
# Terminate already running polybar instances
pkill -x polybar 2>/dev/null || true
while pgrep -u $(id -u) -x polybar >/dev/null 2>&1; do sleep 0.05; done

# Ensure Catppuccin Mocha dark theme is locked
mkdir -p "$HOME/.config/polybar/themes"
cp -f "$HOME/.config/polybar/themes/dark.ini" "$HOME/.config/polybar/colors.ini" 2>/dev/null || true

# Launch main bar
polybar main >/tmp/polybar.log 2>&1 &
