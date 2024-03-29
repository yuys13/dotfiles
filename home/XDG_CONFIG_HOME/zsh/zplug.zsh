zplug "zplug/zplug", hook-build:'zplug --self-manage'

zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions", \
    hook-load:"if [[ -n $SOLARIZED ]]; then ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'; fi"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:3
if zplug check "zsh-users/zsh-history-substring-search"; then
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
fi

zplug "plugins/colored-man-pages", from:oh-my-zsh

zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:"fzf"
zplug "junegunn/fzf", use:shell
zplug "b4b4r07/enhancd", use:init.sh

if [[ -f ${0:A:h}/${$(uname):l}/${0:A:t} ]]; then
    source ${0:A:h}/${$(uname):l}/${0:A:t}
fi

