#!/bin/sh
# Clavier AZERTY francais -- disposition Apple/Mac (fr(mac))
setxkbmap -layout fr -variant mac 2>/dev/null || setxkbmap fr 2>/dev/null || true
[ -f "$HOME/.Xresources" ] && xrdb -merge "$HOME/.Xresources" 2>/dev/null || true

# Variables de session standard
export XDG_CURRENT_DESKTOP=dwm
export XDG_SESSION_TYPE=x11
export TERMINAL=alacritty
export BROWSER=firefox
export EDITOR=micro
export PATH="$HOME/.local/bin:$HOME/.local/bin/bar:$HOME/.opencode/bin:$PATH"

if [ -z "$XDG_RUNTIME_DIR" ]; then
    export XDG_RUNTIME_DIR="/tmp/run-user-$(id -u)"
    mkdir -p "$XDG_RUNTIME_DIR" 2>/dev/null || true
    chmod 700 "$XDG_RUNTIME_DIR" 2>/dev/null || true
fi

# Demons de session D-Bus
dbus-update-activation-environment --all 2>/dev/null || true

# Serveur audio PipeWire
if command -v pipewire >/dev/null 2>&1; then
    pipewire &
    wireplumber &
    pipewire-pulse &
fi

# Syncthing en arriere-plan
if command -v syncthing >/dev/null 2>&1; then
    syncthing --no-browser &
fi

# Compositeur Picom (ombres et fluidite sans lag)
if command -v picom >/dev/null 2>&1; then
    picom -b --backend glx 2>/dev/null || picom -b --backend xrender 2>/dev/null || true
fi

# Gestionnaire de notifications Dunst
if command -v dunst >/dev/null 2>&1; then
    dunst &
fi

# Fond d'ecran Catppuccin Mocha Dark
WALLPAPER="$HOME/Images/wallpapers/vibrant-gate.png"
if [ ! -f "$WALLPAPER" ]; then
    WALLPAPER=$(find "$HOME/Images/wallpapers" -maxdepth 2 -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' \) 2>/dev/null | sort | head -n 1)
fi
if [ -n "$WALLPAPER" ] && command -v feh >/dev/null 2>&1; then
    feh --bg-fill "$WALLPAPER" 2>/dev/null || true
fi

# Barre de statut : Polybar Apple
if [ -x "$HOME/.config/polybar/launch.sh" ]; then
    "$HOME/.config/polybar/launch.sh" &
fi

# Lancement de dwm dans une session D-Bus
libinput-gestures &
clipmenud &
sxhkd &
exec dbus-run-session dwm
