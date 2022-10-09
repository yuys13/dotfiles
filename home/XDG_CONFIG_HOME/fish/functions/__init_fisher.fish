function __init_fisher
    set -q fish_user_paths
    or set -U fish_user_paths ~/bin ~/go/bin

    if not set -q EDITOR
        if type nvim >/dev/null
            set -U EDITOR nvim
        else if type vim >/dev/null
            set -U EDITOR vim
        else if type vi >/dev/null
            set -U EDITOR vi
        end
    end

    set -q FZF_DEFAULT_OPTS
    or set -U FZF_DEFAULT_OPTS --layout=reverse --height 40%

    set -q GHQ_SELECTOR
    or set -U GHQ_SELECTOR fzf

    set -q GHQ_SELECTOR_OPTS
    or set -U GHQ_SELECTOR_OPTS $FZF_DEFAULT_OPTS

    # curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/HEAD/functions/fisher.fish | source && fisher update
    if type fisher >/dev/null
        fisher update
    end
end
