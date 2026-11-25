#!/bin/sh
# ~/.local/bin/lock.sh — Verrouillage d'écran Catppuccin Mocha avec flou, horloge et alerte CapsLock

# Ne pas lancer plusieurs instances simultanées
pgrep -x i3lock >/dev/null && exit 0

# Palette Catppuccin Mocha (Format RRGGBBAA pour i3lock-color)
CRUST_ALPHA=11111b99
BASE_ALPHA=1e1e2ecc
SAPPHIRE=74c7ecff
MAUVE=cba6f7ff
PEACH=fab387ff
RED=f38ba8ff
TEXT=cdd6f4ff
SUBTEXT=a6adc8ff
CLEAR=00000000

exec i3lock     --blur=6     --clock     --indicator     --radius=110     --ring-width=10     --time-str=%H:%M     --time-font=Maple Mono NF     --time-size=68     --time-color=     --date-str=%A %d %B     --date-font=Maple Mono NF     --date-size=18     --date-color=     --inside-color=     --ring-color=     --keyhl-color=     --bshl-color=     --separator-color=     --line-color=     --insidever-color=     --ringver-color=     --insidewrong-color=     --ringwrong-color=     --verif-color=     --wrong-color=     --modif-color=     --verif-font=Maple Mono NF     --wrong-font=Maple Mono NF     --modif-font=Maple Mono NF     --verif-size=18     --wrong-size=18     --modif-size=16     --verif-text=Vérification...     --wrong-text=Mot de passe incorrect     --noinput-text=     --pass-media-keys     --pass-screen-keys     --pass-volume-keys     --pass-power-keys     --ignore-empty-password     --show-failed-attempts
