## Common settings
for rc in ${XDG_CONFIG_HOME}/zsh/common/<->_*.zsh; do
    source $rc
done

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
fi

## Local setting
if [ -f ${XDG_DATA_HOME}/zsh/zshrc ]; then
    source ${XDG_DATA_HOME}/zsh/zshrc
fi

