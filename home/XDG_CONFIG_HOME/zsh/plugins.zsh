() {
    # Repository root
    local ghq_root=${HOME}/src
    local github=${ghq_root}/github.com
    local zsh_users=${github}/zsh-users
    local omz_root=${github}/robbyrussell/oh-my-zsh
    local brew_prefix=$( (( $+commands[brew] )) && brew --prefix || echo /opt/homebrew)

    ## Load plugins
    # powerlevel10k
    if [[ -d ${github}/romkatv/powerlevel10k ]]; then
        source ${github}/romkatv/powerlevel10k/powerlevel10k.zsh-theme
        # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
        [[ ! -f  ${XDG_CONFIG_HOME}/zsh/p10k.zsh ]] || source ${XDG_CONFIG_HOME}/zsh/p10k.zsh
    elif [ -d ${brew_prefix}/share/powerlevel10k ]; then
        source ${brew_prefix}/share/powerlevel10k/powerlevel10k.zsh-theme
        [[ ! -f  ${XDG_CONFIG_HOME}/zsh/p10k.zsh ]] || source ${XDG_CONFIG_HOME}/zsh/p10k.zsh
    elif [ -d /usr/share/zsh-theme-powerlevel10k ]; then
        source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
        [[ ! -f  ${XDG_CONFIG_HOME}/zsh/p10k.zsh ]] || source ${XDG_CONFIG_HOME}/zsh/p10k.zsh
    else
        autoload -Uz promptinit
        promptinit
        setopt transient_rprompt
        prompt yuys13
    fi

    # zsh-completions
    if [[ -d ${zsh_users}/zsh-completions ]]; then
        source ${zsh_users}/zsh-completions/zsh-completions.plugin.zsh
    elif [[ -d ${brew_prefix}/share/zsh-completions ]]; then
        fpath=( ${brew_prefix}/share/zsh-completions $fpath )
    fi

    # zsh-autosuggestions
    if [[ -d ${zsh_users}/zsh-autosuggestions ]]; then
        source ${zsh_users}/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
        ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    elif [[ -d ${brew_prefix}/share/zsh-autosuggestions ]]; then
        source ${brew_prefix}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
        ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    elif [[ -d /usr/share/zsh/plugins/zsh-autosuggestions ]]; then
        source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
        ZSH_AUTOSUGGEST_STRATEGY=(history completion)
    fi

    # fzf
    if [[ -d ${github}/junegunn/fzf ]]; then
        for rc in ${github}/junegunn/fzf/shell/*.zsh; do
            source $rc
        done
    elif [[ -d ${brew_prefix}/opt/fzf ]]; then
        for rc in ${brew_prefix}/opt/fzf/shell/*.zsh; do
            source $rc
        done
    elif [[ -d /usr/share/fzf ]]; then
        for rc in /usr/share/fzf/*.zsh; do
            source $rc
        done
    fi

    gcd () {
        local dir=$(git rev-parse --show-toplevel)
        if [[ -n $dir ]]; then
            builtin cd $dir
        fi
    }

    if (( $+commands[fzf] )); then
        if (( $+commands[fd] )); then
            export FZF_ALT_C_COMMAND="fd -t d"
            export FZF_CTRL_T_COMMAND='fd -t f -L -H -E .git'
        fi
        if (( $+commands[bat] )); then
            export FZF_CTRL_T_OPTS='--preview "bat --color=always --style=header,grid --line-range :100 {}"'
        else
            export FZF_CTRL_T_OPTS='--preview "cat {}"'
        fi

        export FZF_CDR_PREVIEW_OPTS
        if (( $+commands[eza] )); then
            export FZF_ALT_C_OPTS='--preview "eza --icons --tree --level=1 --color=always {}"'
            FZF_CDR_PREVIEW_OPTS="eza --icons --tree --level=1 --color=always "
        elif (( $+commands[exa] )); then
            export FZF_ALT_C_OPTS='--preview "exa --icons --tree --level=1 {}"'
            FZF_CDR_PREVIEW_OPTS="exa --icons --tree --level=1 "
        else
            export FZF_ALT_C_OPTS='--preview "ls --color {}"'
            FZF_CDR_PREVIEW_OPTS="ls --color "
        fi

        if [[ ${COLORTERM} = 'truecolor' ]]; then
            # FZF_DEFAULT_OPTS='--layout=reverse --height 40% --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'
            FZF_DEFAULT_OPTS='--layout=reverse --height 40% --color=fg:#f8f8f2,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'
        fi
        export FZF_DEFAULT_OPTS=${FZF_DEFAULT_OPTS:-"--layout=reverse --height 40%"}
        function bd_list () {
            local dir=$PWD
            for i in {1..20}; do
                dir=$(dirname "$dir")
                echo "$dir"
                if [[ $dir = "/" ]]; then
                    break
                fi
            done
        }

        function bd () {
            local dir=$(bd_list | FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} ${FZF_ALT_C_OPTS}" fzf)
            if [[ -n $dir ]]; then
                builtin cd $dir
            fi
        }

        function cdf () {
            clean-chpwd-recent-dirs
            local dir=($(cdr -l | fzf --preview 'f() { sh -c "$FZF_CDR_PREVIEW_OPTS ${@}" }; f {2..}'))
            if [[ -n $dir ]]; then
                cdr "${dir[1]}"
            fi
        }

        if (( $+commands[ghq] )); then
            ghq_fzf () {
                local selected_repo=$(ghq list -p | FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS} ${FZF_ALT_C_OPTS}" fzf)
                if [[ -z $selected_repo ]]; then
                    zle redisplay
                    return 0
                fi

                BUFFER="cd ${selected_repo}"
                zle accept-line

                zle reset-prompt
            }

            zle -N ghq_fzf
            bindkey "^g" ghq_fzf
        fi
    fi

    ## sourced after all custom widgets have been created
    # zsh-syntax-highlighting
    if [[ -d ${zsh_users}/zsh-syntax-highlighting ]]; then
        source ${zsh_users}/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
    elif [[ -d ${brew_prefix}/share/zsh-syntax-highlighting ]]; then
        source ${brew_prefix}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    elif [[ -d /usr/share/zsh/plugins/zsh-syntax-highlighting ]]; then
        source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
    fi

    autoload -Uz compinit
    compinit
}
