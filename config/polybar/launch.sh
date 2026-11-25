#!/bin/sh
# Terminate already running polybar instances
pkill -x polybar 2>/dev/null || true
while pgrep -u $(id -u) -x polybar >/dev/null 2>&1; do sleep 0.05; done

# Ensure the palette is a relative symlink (dark by default, eink preserved)
mkdir -p "$HOME/.config/polybar/themes"
if [ ! -L "$HOME/.config/polybar/colors.ini" ]; then
    (cd "$HOME/.config/polybar" && ln -sfn themes/dark.ini colors.ini)
fi

# Launch the two cuts bars
: > /tmp/polybar.log
polybar top >>/tmp/polybar.log 2>&1 &
polybar bottom >>/tmp/polybar.log 2>&1 &
