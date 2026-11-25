#!/bin/sh
# Masque/affiche les deux barres Polybar et la réservation dwm associée.
polybar-msg cmd toggle >/dev/null 2>&1 || true
xdotool key --clearmodifiers super+alt+b
