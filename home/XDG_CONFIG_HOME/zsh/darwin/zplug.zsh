zplug "yonchu/hw-zsh-completion", if:"which hw"

# unnecessary "github/hub" for darwin
if which hub > /dev/null 2>&1; then
    eval $(hub alias -s)
fi

