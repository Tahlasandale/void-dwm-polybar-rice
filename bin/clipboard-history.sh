#!/bin/sh
# ~/.local/bin/clipboard-history.sh — Menu historique presse-papier (Win + Maj + V)
export CM_LAUNCHER=dmenu
export CM_HISTLENGTH=50

# Sauvegarder la fenêtre active
ACTIVE_WIN=$(xdotool getactivewindow 2>/dev/null || true)

# Menu dmenu Catppuccin Mocha
clipmenu -c -l 14 -i -p "📋 Presse-papier:" \
    -nb "#1e1e2e" -nf "#cdd6f4" -sb "#f5c2e7" -sf "#1e1e2e"

# Si sélectionné, refocaliser et coller
if [ -n "$ACTIVE_WIN" ]; then
    xdotool windowactivate "$ACTIVE_WIN" 2>/dev/null || true
    sleep 0.05
    WIN_CLASS=$(xprop -id "$ACTIVE_WIN" WM_CLASS 2>/dev/null || true)
    if echo "$WIN_CLASS" | grep -qiE "alacritty|terminal|xterm"; then
        xdotool key --clearmodifiers ctrl+shift+v 2>/dev/null || true
    else
        xdotool key --clearmodifiers ctrl+v 2>/dev/null || true
    fi
fi
