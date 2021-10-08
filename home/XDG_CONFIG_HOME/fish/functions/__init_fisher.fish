function __init_fisher
    set -q fish_user_paths
    or set -U fish_user_paths ~/bin ~/go/bin

    set -q theme_powerline_fonts
    or set -U theme_powerline_fonts no

    set -q theme_nerd_fonts
    or set -U theme_nerd_fonts no

    set -q FZF_DEFAULT_OPTS
    or set -U FZF_DEFAULT_OPTS --layout=reverse --height 40%

    set -q GHQ_SELECTOR
    or set -U GHQ_SELECTOR fzf

    set -q GHQ_SELECTOR_OPTS
    or set -U GHQ_SELECTOR_OPTS $FZF_DEFAULT_OPTS

    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/HEAD/functions/fisher.fish | source && fisher update
end

