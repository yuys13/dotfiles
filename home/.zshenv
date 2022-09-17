## XDG Basic Directory
export XDG_CONFIG_HOME=${HOME}/.config
export XDG_CACHE_HOME=${HOME}/.cache
export XDG_DATA_HOME=${HOME}/.local/share

## Local setting
if [ -f ${XDG_CONFIG_HOME}/zsh/local/zshenv ]; then
    source ${XDG_CONFIG_HOME}/zsh/local/zshenv
fi

# END .zshenv
# touch ~/.config/zsh/local/zshenv
