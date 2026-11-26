# rice

Snapshot local du rice Void Linux + dwm, figé depuis la session live du 2026-11-25.
Les fichiers sont copiés **tels quels** : aucun correctif, aucun tri de mes changements précédents.

## Contenu

- `home/` : `.xinitrc`, `.Xresources`, `.bashrc`, `.bash_aliases`, `.bash_logout`, `.profile`, `.inputrc`
- `config/` : alacritty, dunst, fastfetch, gtk-3.0/4.0, libinput-gestures.conf, micro, oh-my-posh, polybar, sxhkd, yazi (une seule flavor Catppuccin Mocha teal)
- `bin/` : scripts actifs de `~/.local/bin`, dont `bar/`, `dmenu-drun`, `next-wallpaper.sh`, `clipboard-history.sh`, `xdg-open`, `yazi`, `chafa`, `xclip`
- `src/` : sources `dwm` et `dmenu` (sans `.git` imbriqués ni `.o`)
- `wallpapers/` : les 5 images de `~/Images/wallpapers`
- `fonts/` : JetBrainsMono Nerd Font, Font Awesome 6 et Maple Mono NF (Regular/Bold/Italic)
- `tools/opt/` : payloads locaux `xclip`, `chafa` + libs
- `system/` : `pkglist.txt` (paquets installés explicitement, `xbps-query -m`) et configs root (clavier, grub, keyd, `zramen.conf`, `99-zram.conf`)

## Exclusions volontaires

- `~/.local/bin/agy` (263 Mo) et `~/.local/bin/oh-my-posh` (14 Mo) : binaires applicatifs, à installer via xbps.
- Polices non utilisées (Maple Mono Light/Medium/SemiBold/etc., Libron).
- `.Xauthority`, historiques, caches, configs Mozilla/Obsidian/OpenCode/glib/pulse.
- Legacy supprimé : `dwmblocks`, `block-keylocks`, `block-megasync`, `block-theme`, `xbindkeys`, patchs `.orig/.rej/.diff` et variantes Yazi inactives.
- Fichiers générés (`colors.toml`, `dunstrc`, `colors.ini`) stockés sous forme de liens relatifs, pas de doublons.
- Binaires compilés dans `src/` : non versionnés, `make` les reconstruit (les `.o` sont ignorés).
- `git` est un paquet système ; le repo ne le duplique pas.

## Restauration

```sh
./bootstrap.sh          # vérifie git et recopie tools/opt vers ~/.local/opt si absent
./deploy.sh             # crée les liens, y compris les liens de thème relatifs, refuse d'écraser l'existant
./deploy.sh --force     # sauvegarde dans ~/.rice-backup/<horodatage> avant de remplacer
```

`deploy.sh` gère aussi les configs root via `sudo` ; le premier déploiement de `zramen.conf` nécessite `--force` pour remplacer le fichier du paquet par un lien.

## Rebuild des binaires locaux

```sh
make -C src/dwm && cp src/dwm/dwm ~/.local/bin/dwm
make -C src/dmenu && cp src/dmenu/dmenu ~/.local/bin/dmenu
pkill -x dwm   # puis relancer la session
```

## Points notables de l'état figé

- Clavier : `setxkbmap -layout fr -variant mac` (inchangé).
- Curseur : `Xcursor.size: 48`, `xrdb -merge ~/.Xresources` au login, GTK `prefer-dark`.
- Rotation fonds : `Ctrl+!` → `next-wallpaper.sh`, dossier `~/Images/wallpapers`.
- Polybar : style `cuts` (adi1090x), une seule barre active (`top` ; `[bar/main]` reste en config), fond ARGB `#3374c7ec` (alpha `0x33`) rendu translucide par Picom, modules `#11111b`, primaire `#94e2d5` ; dwm réserve 28 px en bas. Anciennes configs dans `backups/polybar-*.tar.gz`.
- Barres : `Super+b` / `Alt+Maj+b` masque/affiche les barres via `toggle-bars.sh`.
- Picom : `picom -b --backend glx` au login (transparence réelle ; fallback `xrender`).
- Énergie & Autonomie : TLP 1.10.2 activé via runit. Optimisation PCIe ASPM dynamique via `system/00-macbook-aspm.conf` lié dans `/etc/tlp.d/` (`PCIE_ASPM_ON_BAT=powersave`, `PCIE_ASPM_ON_AC=default`). Mesures réelles de consommation au repos sur batterie à 50% de luminosité (1389/2777, Firefox fermé) :
  - Baseline initiale (scripts Polybar Python) : 8,98 W (~6,0h d'autonomie)
  - Polybar optimisée en pur shell (`8e27f6f`) : 5,06 W (~10,6h d'autonomie)
  - PCIe ASPM `powersave` activé : **3,66 W** (~14,7h d'autonomie théorique sur batterie 54 Wh)
  - Ventilateur piloté par `applesmc`.
- zram : `zramen` (zstd, ~2 GiB, priorité 32767) activé via `/var/service/zramen`, conf liée depuis `system/zramen.conf`.
- Swap zram : `vm.swappiness=100` et `vm.page-cluster=0` via `system/99-zram.conf`, lié dans `/etc/sysctl.d/` et appliqué au boot par `/etc/runit/core-services/08-sysctl.sh`. Compression mesurée : `DATA ≈ 3 × COMPR`.
- dmenu : prompt aligné sur les entrées, palette Catppuccin + coins arrondis compilés.
- Alimentation : clic droit sur l'horloge → `bar/power-menu` (fenêtre dmenu, plus de terminal) ; le mot de passe sudo est demandé par `bar/sudo-askpass` via dmenu.
- Bordures dwm : active `#94e2d5`, inactive `#11111b`, épaisseur 5 px.
- Presse-papiers : `sxhkd` `Win+Maj+V` → `clipboard-history.sh` (`clipmenu`), `clipmenud` au login ; captures = image en CLIPBOARD + chemin en PRIMARY.
- Yazi : wrapper qui force le driver Chafa sous X11/Alacritty.
- `xdg-open` : wrapper local temporaire ; installer `xdg-utils` (`sudo xbps-install -S xdg-utils`) puis retirer le wrapper.
