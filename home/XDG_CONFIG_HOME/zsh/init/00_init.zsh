# INIT
## Path
typeset -U path cdpath fpath manpath

export GOPATH=${HOME}/go

path=( \
    ${HOME}/bin(N-/) \
    /opt/homebrew/bin(N-/) \
    ${HOME}/.zplug/bin(N-/) \
    ${GOPATH}/bin(N-/) \
    ${HOME}/.luarocks/bin(N-/) \
    ${HOME}/.local/bin(N-/) \
    $path \
)
fpath=( \
    ${XDG_CONFIG_HOME}/zsh/functions(N-/) \
    /opt/homebrew/share/zsh/site-functions(N-/) \
    $fpath \
)

## Editor
if test -n ${EDITOR} -a "${EDITOR[(w)0]}" = 'nvr'; then
    export EDITOR
elif type nvim >/dev/null 2>&1; then
    export EDITOR=nvim
elif type vim >/dev/null 2>&1; then
    export EDITOR=vim
else
    export EDITOR=vi
fi

# COMMON
setopt nobeep
setopt print_eight_bit
setopt ignore_eof
autoload -Uz add-zsh-hook

## KEY BIND
bindkey -e
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

## HISTORY
HISTFILE=${XDG_DATA_HOME}/zsh/histfile
HISTSIZE=10000
SAVEHIST=${HISTSIZE}
setopt share_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_no_store
setopt hist_verify

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
        if type gls >/dev/null 2>&1; then
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

# cdr
autoload -Uz chpwd_recent_dirs cdr
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-default true
zstyle ':chpwd:*' recent-dirs-file ${XDG_DATA_HOME}/zsh/chpwd-recent-dirs
zstyle ':chpwd:*' recent-dirs-max 500
# zstyle ':chpwd:*' recent-dirs-prune parent
zstyle ':chpwd:*' recent-dirs-pushd true
zstyle ':completion:*:*:cdr:*:*' menu selecttion
zstyle ':completion:*:*:cdr:*:*' recent-dirs-insert both


clean-chpwd-recent-dirs () {
    emulate -L zsh
    setopt extendedglob
    local -aU reply
    integer history_size
    autoload -Uz chpwd_recent_filehandler
    chpwd_recent_filehandler
    history_size=$#reply
    reply=(${^reply}(N))
    (( $history_size == $#reply )) || chpwd_recent_filehandler $reply
}

## GLOB
setopt glob_dots
setopt extended_glob

##
autoload -Uz select-word-style
select-word-style normal
zstyle ':zle:*' word-style normal
zstyle ':zle:*' word-chars ${${WORDCHARS:s,/,,}//=/}
setopt magic_equal_subst

