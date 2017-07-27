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

