# rice

Snapshot local du rice Void Linux + dwm, figé depuis la session live du 2026-11-25.
Les fichiers sont copiés **tels quels** : aucun correctif, aucun tri de mes changements précédents.

## Contenu

- `home/` : `.xinitrc`, `.Xresources`, `.bashrc`, `.bash_aliases`, `.bash_logout`, `.profile`, `.inputrc`, `.xbindkeysrc`
- `config/` : alacritty, dunst, fastfetch, gtk-3.0/4.0, libinput-gestures.conf, micro, oh-my-posh, polybar, sxhkd, yazi (+ flavors)
- `bin/` : tous les scripts utiles de `~/.local/bin`, dont `bar/`, `dmenu-drun`, `next-wallpaper.sh`, `clipboard-history.sh`, `clipboard-menu.sh`, `xdg-open`, `yazi`, `chafa`, `xclip`
- `src/` : sources `dwm`, `dmenu`, `dwmblocks` (sans `.git` imbriqués ni `.o`)
- `wallpapers/` : les 5 images de `~/Images/wallpapers`
- `fonts/` : JetBrainsMono Nerd Font + Font Awesome 6 (celles référencées par la barre/le terminal)
- `tools/opt/` : payloads locaux `xclip`, `chafa` + libs, `xbindkeys`
- `system/pkglist.txt` : paquets installés explicitement (`xbps-query -m`)

## Exclusions volontaires

- `~/.local/bin/agy` (263 Mo) et `~/.local/bin/oh-my-posh` (14 Mo) : binaires applicatifs, à installer via xbps.
- Polices non référencées (`MapleMono`, `Libron`).
- `.Xauthority`, historiques, caches, configs Mozilla/Obsidian/OpenCode/glib/pulse.
- Binaires compilés dans `src/` : `bin/dwm` et `bin/dmenu` sont conservés, les `.o` sont ignorés.
- `git` est un paquet système ; le repo ne le duplique pas.

## Restauration

```sh
./bootstrap.sh          # vérifie git et recopie tools/opt vers ~/.local/opt si absent
./deploy.sh             # crée des liens symboliques, refuse d'écraser l'existant
./deploy.sh --force     # sauvegarde dans ~/.rice-backup/<horodatage> avant de remplacer
```

## Rebuild des binaires locaux

```sh
make -C src/dwm && cp src/dwm/dwm ~/.local/bin/dwm
make -C src/dmenu && cp src/dmenu/dmenu ~/.local/bin/dmenu
pkill -x dwm   # puis relancer la session
```

## Points notables de l'état figé

- Clavier : `setxkbmap -layout fr -variant mac`.
- Rotation fonds : `Ctrl+!` → `next-wallpaper.sh`, dossier `~/Images/wallpapers`.
- Polybar : `override-redirect = false`, couleur primaire `#94e2d5`.
- dmenu : thème dark/eink dans `dmenu-drun`, palette Catppuccin + coins arrondis compilés.
- Presse-papiers : `sxhkd` `Win+Maj+V` → `clipboard-history.sh` (`clipmenu`), `clipmenud` au login.
- Yazi : wrapper qui force le driver Chafa sous X11/Alacritty.
- `xdg-open` : wrapper local `firefox` / `gio` / `feh`.
