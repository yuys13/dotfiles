# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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
else
    source ${XDG_CONFIG_HOME}/zsh/plugins.zsh
fi

## Local setting
if [ -f ${XDG_CONFIG_HOME}/zsh/local/zshrc ]; then
    source ${XDG_CONFIG_HOME}/zsh/local/zshrc
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# END .zshrc
# touch ~/.config/zsh/local/zshrc

