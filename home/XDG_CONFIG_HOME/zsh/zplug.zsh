zplug "zplug/zplug", hook-build:'zplug --self-manage'

zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-history-substring-search", defer:3
if zplug check "zsh-users/zsh-history-substring-search"; then
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
fi

zplug "plugins/colored-man-pages", from:oh-my-zsh

zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:"fzf"
zplug "junegunn/fzf", use:shell
zplug "jhawthorn/fzy", as:command, if:"which cc", hook-build:'make'
zplug "b4b4r07/enhancd", use:init.sh

zplug "tkengo/highway", as:command, if:"which gcc && which autoconf && which automake", hook-build:"tools/build.sh", use:hw
zplug "yonchu/hw-zsh-completion", on:"tkengo/highway"

zplug "github/hub", if:"which hub"
if zplug check "github/hub" && which hub > /dev/null 2>&1; then
    if [ ! -L ${XDG_DATA_HOME}/zsh/functions/_hub ]; then
        if [ ! -d ${XDG_DATA_HOME}/zsh/functions ]; then
            mkdir -p ${XDG_DATA_HOME}/zsh/functions
            fpath=(${XDG_DATA_HOME}/zsh/functions(N-/) $fpath)
        fi
        ln -s ${ZPLUG_REPOS}/github/hub/etc/hub.zsh_completion ${XDG_DATA_HOME}/zsh/functions/_hub
    fi
    eval $(hub alias -s)
fi
#zplug "github/hub", as:command, from:gh-r

