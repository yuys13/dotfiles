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
function __update_terminai_message() {
    echo -ne "\033]0;${USER}@${HOST}:${PWD/${HOME}/~}\007"
}
case "${TERM}" in
kterm* | xterm*)
    add-zsh-hook precmd __update_terminai_message
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
# coloes
case ${OSTYPE} in
    darwin*)
        export CLICOLOR=1
        alias ls='ls -G'
        ;;
    linux*)
        alias ls='ls -F --color=auto'
        ;;
esac
# alias
alias la='ls -a'
alias ll='ls -l'
# after cd
__list_directory_contents () { ls }
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
