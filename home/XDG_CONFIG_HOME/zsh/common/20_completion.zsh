## COMPLETION
autoload -Uz compinit
compinit

zstyle ':completion:*' verbose yes
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list #_history

zstyle ':completion:*' group-name ''
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:descriptions' format '%B%F{yellow}Completing %d%f%b'
zstyle ':completion:*:corrections' format ' %B%F{yellow}%d %F{red}(errors: %e)%f%b'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
#zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s

zstyle ':completion:*:default' menu select=2
if [ -n "$LS_COLORS" ]; then
    zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
elif which gdircolors > /dev/null; then
    eval "$(gdircolors -b)"
    zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
else
    zstyle ':completion:*:default' list-colors ''
fi

zstyle ':completion:*' ignore-parents parent pwd #..

