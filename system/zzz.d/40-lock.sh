#!/bin/sh
# Verrouille la session avant la mise en veille : l'écran est déjà locké au réveil.
[ -f /home/bison/.Xauthority ] || exit 0

runuser -u bison -- env DISPLAY=:0 XAUTHORITY=/home/bison/.Xauthority \
    /home/bison/.local/bin/lock.sh >/dev/null 2>&1 &
exit 0
