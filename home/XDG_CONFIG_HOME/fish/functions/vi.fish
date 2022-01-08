# Defined in - @ line 1
function vi --wraps='$EDITOR' --description 'alias vi $EDITOR'
    if test "$EDITOR" = vi
        command vi $argv
    else
        eval $EDITOR $argv
    end
end
