#!/bin/sh
# Terminate already running polybar instances
pkill -x polybar 2>/dev/null || true
while pgrep -u $(id -u) -x polybar >/dev/null 2>&1; do sleep 0.05; done

# Ensure relative symlink points to dark.ini
mkdir -p "$HOME/.config/polybar/themes"
(cd "$HOME/.config/polybar" && ln -sfn themes/dark.ini colors.ini)

# Launch the single cuts top bar
: > /tmp/polybar.log
polybar top >>/tmp/polybar.log 2>&1 &
