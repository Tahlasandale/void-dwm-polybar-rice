#!/bin/sh
# Vérifie les prérequis et restaure les payloads locaux sans toucher au reste.
set -eu

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

if ! command -v git >/dev/null 2>&1; then
    echo "git absent : installe-le (xbps-install -S git) avant de continuer." >&2
    exit 1
fi

mkdir -p "$HOME/.local/opt"
for d in "$ROOT"/tools/opt/*; do
    [ -d "$d" ] || continue
    name=$(basename "$d")
    if [ -e "$HOME/.local/opt/$name" ]; then
        echo "déjà présent : ~/.local/opt/$name"
    else
        cp -a "$d" "$HOME/.local/opt/$name"
        echo "restauré : ~/.local/opt/$name"
    fi
done

echo "Prérequis OK. Lance ./deploy.sh pour relier les configs et scripts."
