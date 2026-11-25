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

for f in "$ROOT"/home/.*; do
    base=$(basename "$f")
    [ "$base" = "." ] && continue
    [ "$base" = ".." ] && continue
    link "$f" "$HOME/$base"
done

for f in "$ROOT"/config/*; do
    link "$f" "$HOME/.config/$(basename "$f")"
done

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

echo "Terminé. Sauvegardes (si --force) : $BACKUP"
