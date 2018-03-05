zplug "jhawthorn/fzy", as:command, if:"which cc", hook-build:'make'

zplug "tkengo/highway", as:command, if:"which gcc && which autoconf && which automake", hook-build:"tools/build.sh", use:hw
zplug "yonchu/hw-zsh-completion", on:"tkengo/highway"

zplug "motemen/ghq", use:"zsh", if:"which go", hook-build:"go get -u github.com/motemen/ghq"

