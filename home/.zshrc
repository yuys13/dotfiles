## Initial settings
for rc in ${XDG_CONFIG_HOME}/zsh/init/<->_*.zsh; do
    source $rc
done

## Local initial settings
if [[ -d ${XDG_CONFIG_HOME}/zsh/local/init ]]; then
    for rc in ${XDG_CONFIG_HOME}/zsh/local/init/<->_*.zsh; do
        source $rc
    done
fi

## per OSType
if [ -f ${XDG_CONFIG_HOME}/zsh/${$(uname):l}/zshrc ]; then
    source ${XDG_CONFIG_HOME}/zsh/${$(uname):l}/zshrc
fi

## Plugins
if [[ -f ~/.zplug/init.zsh ]]; then
    source ~/.zplug/init.zsh
    source ${XDG_CONFIG_HOME}/zsh/zplug.zsh
    #export ZPLUG_LOADFILE=${XDG_CONFIG_HOME}/zsh/zplug.zsh

    if ! zplug check --verbose; then
        printf "install? [y/N]: "
        if read -q; then
            echo; zplug install
        fi
        echo
    fi
    zplug load #--verbose
    # Oops .zplug/init.zsh cannot use hub alias
    if type hub > /dev/null 2>&1; then
        eval "$(hub alias -s)"
    fi
elif type ghq > /dev/null; then
    source ${XDG_CONFIG_HOME}/zsh/plugins.zsh
else
    autoload -Uz compinit
    compinit
fi

## Local setting
if [ -f ${XDG_CONFIG_HOME}/zsh/local/zshrc ]; then
    source ${XDG_CONFIG_HOME}/zsh/local/zshrc
fi

# END .zshrc
# touch ~/.config/zsh/local/zshrc
