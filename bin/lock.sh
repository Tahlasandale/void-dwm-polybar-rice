#!/bin/sh
# ~/.local/bin/lock.sh — Verrouillage d'écran Catppuccin Mocha avec flou, horloge et alerte CapsLock

pgrep -x i3lock >/dev/null && exit 0

CRUST_ALPHA="11111b99"
BASE_ALPHA="1e1e2ecc"
SAPPHIRE="74c7ecff"
MAUVE="cba6f7ff"
PEACH="fab387ff"
RED="f38ba8ff"
TEXT="cdd6f4ff"
SUBTEXT="a6adc8ff"
CLEAR="00000000"

exec i3lock     --blur=6     --clock     --indicator     --radius=140     --ring-width=12     --time-str="%H:%M"     --time-font="Maple Mono NF"     --time-size=56     --time-pos="ix:iy+21"     --time-align=0     --time-color="${TEXT}"     --date-str="%A %d %B"     --date-font="Maple Mono NF"     --date-size=15     --date-pos="tx:ty+45"     --date-align=0     --date-color="${SUBTEXT}"     --inside-color="${CRUST_ALPHA}"     --ring-color="${SAPPHIRE}"     --keyhl-color="${MAUVE}"     --bshl-color="${RED}"     --separator-color="${CLEAR}"     --line-color="${CLEAR}"     --insidever-color="${BASE_ALPHA}"     --ringver-color="${SAPPHIRE}"     --insidewrong-color="${BASE_ALPHA}"     --ringwrong-color="${RED}"     --verif-color="${TEXT}"     --wrong-color="${RED}"     --modif-color="${PEACH}"     --verif-font="Maple Mono NF"     --wrong-font="Maple Mono NF"     --verif-size=18     --wrong-size=16     --verif-pos="ix:iy+7"     --wrong-pos="ix:iy+7"     --verif-align=0     --wrong-align=0     --verif-text="Vérification..."     --wrong-text="Mot de passe erroné"     --noinput-text=""     --pass-media-keys     --pass-screen-keys     --pass-volume-keys     --pass-power-keys     --ignore-empty-password     --show-failed-attempts
