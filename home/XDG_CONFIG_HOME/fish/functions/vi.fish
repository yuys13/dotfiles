# Defined in - @ line 1
function vi --wraps='$EDITOR' --description 'alias vi $EDITOR'
    if test -z "$EDITOR"
        command vi $argv
    else
        eval $EDITOR $argv
    end
end
