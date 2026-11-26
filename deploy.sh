#!/bin/sh
# Relie le repo vers le home. Sans --force, n'écrase jamais l'existant.
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
FORCE=0
[ "${1:-}" = "--force" ] && FORCE=1
BACKUP="$HOME/.rice-backup/$(date +%Y%m%d-%H%M%S)"

link() {
    src=$1
    dst=$2
    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
        return
    fi
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        if [ "$FORCE" -ne 1 ]; then
            echo "SKIP $dst (existe)"
            return
        fi
        rel=${dst#"$HOME"/}
        mkdir -p "$BACKUP/$(dirname "$rel")"
        cp -a "$dst" "$BACKUP/$rel" 2>/dev/null || true
        rm -rf "$dst"
    fi
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
    echo "LIEN $dst -> $src"
}

link_root() {
    src=$1
    dst=$2
    if [ "$(sudo readlink "$dst" 2>/dev/null || true)" = "$src" ]; then
        return
    fi
    if sudo test -e "$dst" || sudo test -L "$dst"; then
        if [ "$FORCE" -ne 1 ]; then
            echo "SKIP ROOT $dst (existe)"
            return
        fi
        rel=${dst#/}
        mkdir -p "$BACKUP/root/$(dirname "$rel")"
        sudo cp -a "$dst" "$BACKUP/root/$rel" 2>/dev/null || true
        sudo rm -f "$dst"
    fi
    sudo mkdir -p "$(dirname "$dst")"
    sudo ln -s "$src" "$dst"
    echo "LIEN ROOT $dst -> $src"
}

for f in "$ROOT"/home/.*; do
    base=$(basename "$f")
    [ "$base" = "." ] && continue
    [ "$base" = ".." ] && continue
    link "$f" "$HOME/$base"
done

for f in "$ROOT"/config/*; do
    link "$f" "$HOME/.config/$(basename "$f")"
done

# Fichiers de thème générés : liens relatifs vers la palette dark fixe
mkdir -p "$HOME/.config/alacritty" "$HOME/.config/dunst" "$HOME/.config/polybar"
(cd "$HOME/.config/alacritty" && ln -sfn themes/catppuccin-mocha.toml colors.toml)
(cd "$HOME/.config/dunst" && ln -sfn dunstrc-dark dunstrc)
(cd "$HOME/.config/polybar" && ln -sfn themes/dark.ini colors.ini)
(cd "$HOME/.config/alacritty" && ln -sfn fonts/maple-mono.toml font.toml)

mkdir -p "$HOME/.local/bin/bar"
for f in "$ROOT"/bin/*; do
    [ -f "$f" ] || continue
    link "$f" "$HOME/.local/bin/$(basename "$f")"
done
for f in "$ROOT"/bin/bar/*; do
    [ -f "$f" ] || continue
    link "$f" "$HOME/.local/bin/bar/$(basename "$f")"
done

mkdir -p "$HOME/.local/share/fonts"
for f in "$ROOT"/fonts/*; do
    link "$f" "$HOME/.local/share/fonts/$(basename "$f")"
done

mkdir -p "$HOME/.local/opt"
for d in "$ROOT"/tools/opt/*; do
    [ -d "$d" ] || continue
    link "$d" "$HOME/.local/opt/$(basename "$d")"
done

mkdir -p "$HOME/Images"
link "$ROOT/wallpapers" "$HOME/Images/wallpapers"

link_root "$ROOT/system/zramen.conf" /etc/sv/zramen/conf
link_root "$ROOT/system/99-zram.conf" /etc/sysctl.d/99-zram.conf
link_root "$ROOT/system/00-macbook-aspm.conf" /etc/tlp.d/00-macbook-aspm.conf

echo "Terminé. Sauvegardes (si --force) : $BACKUP"
