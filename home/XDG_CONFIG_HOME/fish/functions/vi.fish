# Defined in - @ line 1
function vi --wraps='$EDITOR' --description 'alias vi $EDITOR'
    eval $EDITOR $argv
end
