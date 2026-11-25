# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# PATH export
export PATH="$HOME/.local/bin:$HOME/.local/bin/bar:$HOME/.opencode/bin:$PATH"

# Aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Oh My Posh Catppuccin Prompt
if [ -x "$HOME/.local/bin/oh-my-posh" ] && [ -f "$HOME/.config/oh-my-posh/catppuccin.omp.json" ]; then
    eval "$("$HOME/.local/bin/oh-my-posh" init bash --config "$HOME/.config/oh-my-posh/catppuccin.omp.json")"
fi

# Minifetch Catppuccin
if command -v fastfetch >/dev/null 2>&1 && [ -f "$HOME/.config/fastfetch/minifetch.jsonc" ]; then
    alias minifetch='fastfetch --config ~/.config/fastfetch/minifetch.jsonc'
    fastfetch --config ~/.config/fastfetch/minifetch.jsonc
fi
