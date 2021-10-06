() {
    # Repository root
    local ghq_root=${HOME}/dev/src
    local github=${ghq_root}/github.com
    local zsh_users=${github}/zsh-users
    local omz_root=${github}/robbyrussell/oh-my-zsh

    ## Load plugins
    # zsh-completions
    if [ -d ${zsh_users}/zsh-completions ]; then
        source ${zsh_users}/zsh-completions/zsh-completions.plugin.zsh
    fi

    # zsh-autosuggestions
    if [ -d ${zsh-users}/zsh-autosuggestions ]; then
        source ${zsh_users}/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
        if [[ -n $SOLARIZED ]]; then
            ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10';
        fi
    fi

    # fzf
    if [ -d ${github}/junegunn/fzf ]; then
        export FZF_CTRL_R_OPTS="--layout=reverse"
        if type fd > /dev/null 2>&1; then
            export FZF_ALT_C_COMMAND="fd -t d"
        fi

        for rc in ${github}/junegunn/fzf/shell/*.zsh; do
            source $rc
        done
    fi

    gcd () {
        local dir=$(git rev-parse --show-toplevel)
        if [ -n "$dir" ]; then
            builtin cd $dir
        fi
    }

    if type fzf > /dev/null; then
        function bd_list () {
            local dir=$PWD
            for i in {1..20}; do
                dir=$(dirname "$dir")
                echo "$dir"
                if [ "$dir" = "/" ]; then
                    break
                fi
            done
        }

        function bd () {
            local dir=$(bd_list | fzf --reverse --height 40%)
            if [ -n "$dir" ]; then
                builtin cd $dir
            fi
        }

        if type ghq > /dev/null; then
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
    fi

    # ghq
    fpath=( \
        ${github}/x-motemen/ghq/misc/zsh(N-/) \
        $fpath \
    )

    ## sourced after all custom widgets have been created
    # zsh-syntax-highlighting
    if [ -d ${zsh_users}/zsh-syntax-highlighting ]; then
        source ${zsh_users}/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
    fi

    autoload -Uz compinit
    compinit
}
