#!/bin/sh
# Verrouille la session AVANT la mise en veille : zzz attend ce hook, donc on
# ne suspend qu'une fois i3lock réellement actif (l'écran est locké au réveil).
[ -f /home/bison/.Xauthority ] || exit 0

runuser -u bison -- env DISPLAY=:0 XAUTHORITY=/home/bison/.Xauthority \
    /home/bison/.local/bin/lock.sh >/dev/null 2>&1 &

# Attendre jusqu'à 5 s que i3lock soit affiché ; ne jamais bloquer la veille.
i=0
while [ "$i" -lt 25 ]; do
    pgrep -x i3lock >/dev/null 2>&1 && exit 0
    sleep 0.2
    i=$((i + 1))
done
exit 0
