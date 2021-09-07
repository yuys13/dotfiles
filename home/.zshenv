## XDG Basic Directory
export XDG_CONFIG_HOME=${HOME}/.config
export XDG_CACHE_HOME=${HOME}/.cache
export XDG_DATA_HOME=${HOME}/.local/share

## History
export HISTFILE=${XDG_DATA_HOME}/zsh/histfile
export HISTSIZE=10000
export SAVEHIST=${HISTSIZE}

## Local setting
if [ -f ${XDG_CONFIG_HOME}/zsh/local/zshenv ]; then
    source ${XDG_CONFIG_HOME}/zsh/local/zshenv
fi

