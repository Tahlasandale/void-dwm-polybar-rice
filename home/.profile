# .bash_profile

# Chargement de l'environnement interactif (.bashrc, aliases, prompt)
[ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"

# Lancement automatique de l'environnement graphique dwm sur la console physique tty1
if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec startx
fi
