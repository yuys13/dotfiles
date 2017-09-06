if ! type ghq >/dev/null 2>&1; then
    return
fi
if ! type fzf >/dev/null 2>&1; then
    return
fi

if [ -z "${GHQ_FZF_OPTS}" ]; then
    typeset -g -a GHQ_FZF_OPTS
    GHQ_FZF_OPTS=(--reverse -0 -1)
fi
if [ -z "${GHQ_FZF_GREP_TOOL}" ]; then
    if type hw >/dev/null 2>&1; then
        export GHQ_FZF_GREP_TOOL="hw"
        export GHQ_FZF_GREP_OPTS=(-e )
    else
        export GHQ_FZF_GREP_TOOL="grep"
    fi
fi

fpath=(${0:A:h}/functions(N-/) $fpath)
autoload ghq-fzf

