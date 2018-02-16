## XDG Basic Directory
export XDG_CONFIG_HOME=${HOME}/.config
export XDG_CACHE_HOME=${HOME}/.cache
export XDG_DATA_HOME=${HOME}/.local/share

## History
export HISTFILE=${XDG_DATA_HOME}/zsh/histfile
export HISTSIZE=10000
export SAVEHIST=${HISTSIZE}

## Path
typeset -U path cdpath fpath manpath
typeset -gxTU INFOPATH infopath

export GOPATH=${HOME}/go

path=( \
    ${HOME}/bin(N-/) \
    ${HOME}/.linuxbrew/bin(N-/) \
    ${HOME}/.linuxbrew/sbin(N-/) \
    ${HOME}/.zplug/bin(N-/) \
    ${GOPATH}/bin(N-/) \
    ${HOME}/.local/bin(N-/) \
    $path \
)
fpath=( \
    ${XDG_CONFIG_HOME}/zsh/functions(N-/) \
    ${HOME}/.linuxbrew/share/zsh/site-functions(N-/) \
    $fpath \
)
manpath=( \
    ${HOME}/.linuxbrew/share/man(N-/) \
    $manpath \
)
infopath=( \
    ${HOME}/.linuxbrew/share/info(N-/) \
    $infopath \
)

## dir color
if [ -z "${LS_COLORS}" ]; then
    if which dircolors > /dev/null; then
        eval "$(dircolors -b)"
    fi
fi

## Editor
if which nvim > /dev/null 2>&1; then
    export EDITOR=nvim
elif which vim > /dev/null 2>&1; then
    export EDITOR=vim
else
    export EDITOR=vi
fi

## Local setting
if [ -f ${XDG_CONFIG_HOME}/zsh/local/zshenv ]; then
    source ${XDG_CONFIG_HOME}/zsh/local/zshenv
fi

