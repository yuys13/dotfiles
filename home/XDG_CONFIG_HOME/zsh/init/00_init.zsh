## INIT
# COMMON
setopt nobeep
setopt print_eight_bit
setopt ignore_eof
autoload -Uz add-zsh-hook

## KEY BIND
bindkey -e

## HISTORY
setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks

## TERMINAL
function __update_terminal_message() {
    echo -ne "\033]0;${USER}@${HOST}:${PWD/${HOME}/~}\007"
}
case "${TERM}" in
    kterm* | xterm*)
        add-zsh-hook precmd __update_terminal_message
        ;;
esac

# display exec cmd
#setopt xtrace

## EXIT CODE
setopt print_exit_value
REPORTTIME=3

## DIRECTORY
setopt auto_pushd
setopt pushd_ignore_dups
# colors
autoload -Uz solarize
if [[ -f ${XDG_DATA_HOME%/}/zsh/solarized ]]; then
    solarize
fi
case ${OSTYPE} in
    darwin*)
        if which gls > /dev/null 2>&1; then
            alias ls='gls -F --color=auto'
        else
            export CLICOLOR=1
            alias ls='ls -G'
        fi
        ;;
    linux*)
        alias ls='ls -F --color=auto'
        ;;
esac
# alias
alias la='ls -a'
alias l.='ls -d .*'
alias ll='ls -l'
alias lla='ls -la'
alias ll.='ls -l -d .*'
if test -n ${EDITOR}; then
    alias vi=${EDITOR}
fi

# after cd
__list_directory_contents () {
    if [[ -o interactive ]]; then
        ls
    fi
}
add-zsh-hook chpwd __list_directory_contents

## GLOB
setopt glob_dots
setopt extended_glob

##
autoload -Uz select-word-style
select-word-style normal
zstyle ':zle:*' word-style normal
zstyle ':zle:*' word-chars ${${WORDCHARS:s,/,,}//=/}
setopt magic_equal_subst

