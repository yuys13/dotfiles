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

export GOPATH=${HOME}/go

path=( \
    ${HOME}/bin(N-/) \
    ${HOME}/.zplug/bin(N-/) \
    ${GOPATH}/bin(N-/) \
    ${HOME}/.local/bin(N-/) \
    $path \
)
fpath=( \
    ${XDG_CONFIG_HOME}/zsh/functions(N-/) \
    $fpath \
)

## Editor
if test -n ${EDITOR} -a "${EDITOR[(w)0]}" = 'nvr'; then
    export EDITOR
elif which nvim > /dev/null 2>&1; then
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

