## PROMPT
PROMPT="%{${fg[green]}%}[%n@%m]%{${reset_color}%} %~
%(!.#.$) "

#RPROMPT="%D %*"
RPROMPT="%*"
setopt transient_rprompt

setopt prompt_subst

autoload -Uz vcs_info

zstyle ':vcs_info:*' formats "(%F{magenta}%s%f)-[%F{green}%b%f]%u%c"
zstyle ':vcs_info:*' actionformats "(%F{magenta}%s%f)-[%F{green}%b%f|%a]%u%c"

zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{yellow}!%f"
zstyle ':vcs_info:git:*' unstagedstr "%F{red}+%f"

zstyle ':vcs_info:(svn|bzr):*' branchformats "%b%f:r%r"

add-zsh-hook precmd vcs_info

RPROMPT='${vcs_info_msg_0_} '${RPROMPT}

