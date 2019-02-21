() {
    # Repository root
    local ghq_root=$(ghq root)
    local omz_root=${ghq_root}/github.com/robbyrussell/oh-my-zsh

    ## Load plugins
    # zsh-completions
    if [ -d ${ghq_root}/github.com/zsh-users/zsh-completions ]; then
        source ${ghq_root}/github.com/zsh-users/zsh-completions/zsh-completions.plugin.zsh
    fi

    # zsh-autosuggestions
    if [ -d ${ghq_root}/github.com/zsh-users/zsh-autosuggestions ]; then
        source ${ghq_root}/github.com/zsh-users/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
        if [[ -n $SOLARIZED ]]; then
            ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10';
        fi
    fi

    # fzf
    if [ -d ${ghq_root}/github.com/junegunn/fzf ]; then
        export FZF_CTRL_R_OPTS="--layout=reverse"
        for rc in ${ghq_root}/github.com/junegunn/fzf/shell/*.zsh; do
            source $rc
        done
    fi

    if type fzf > /dev/null; then # ghq already checked
        ghq_fzf () {
            local selected_repo=$(ghq list -p | fzf --reverse --height 40%)
            if [[ -z $selected_repo ]]; then
                zle redisplay
                return 0
            fi

            BUFFER=" cd ${selected_repo}"
            zle accept-line

            zle reset-prompt
        }

        zle -N ghq_fzf
        bindkey "^g" ghq_fzf
    fi

    # ghq
    fpath=( \
        ${GOPATH}/src/github.com/motemen/ghq/zsh(N-/) \
        $fpath \
    )

    ## sourced after all custom widgets have been created
    # zsh-syntax-highlighting
    if [ -d ${ghq_root}/github.com/zsh-users/zsh-syntax-highlighting ]; then
        source ${ghq_root}/github.com/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
    fi

    autoload -Uz compinit
    compinit
}
