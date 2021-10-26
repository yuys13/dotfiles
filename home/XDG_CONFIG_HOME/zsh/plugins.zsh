() {
    # Repository root
    local ghq_root=${HOME}/src
    local github=${ghq_root}/github.com
    local zsh_users=${github}/zsh-users
    local omz_root=${github}/robbyrussell/oh-my-zsh

    ## Load plugins
    # powerlevel10k
    if [ -d ${github}/romkatv/powerlevel10k ]; then
        source ${github}/romkatv/powerlevel10k/powerlevel10k.zsh-theme
        # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
        [[ ! -f  ${XDG_CONFIG_HOME}/zsh/p10k.zsh ]] || source ${XDG_CONFIG_HOME}/zsh/p10k.zsh
    else
        prompt yuys13
    fi

    # zsh-completions
    if [ -d ${zsh_users}/zsh-completions ]; then
        source ${zsh_users}/zsh-completions/zsh-completions.plugin.zsh
    fi

    # zsh-autosuggestions
    if [ -d ${zsh_users}/zsh-autosuggestions ]; then
        source ${zsh_users}/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
        ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    fi

    # fzf
    if [ -d ${github}/junegunn/fzf ]; then
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
        export FZF_DEFAULT_OPTS=${FZF_DEFAULT_OPTS:-"--layout=reverse --height 40%"}
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
            local dir=$(bd_list | fzf)
            if [ -n "$dir" ]; then
                builtin cd $dir
            fi
        }

        if type ghq > /dev/null; then
            ghq_fzf () {
                local selected_repo=$(ghq list -p | fzf)
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
