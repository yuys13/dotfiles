setlocal shiftwidth=2
setlocal tabstop=2
setlocal softtabstop=2

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|'
else
  let b:undo_ftplugin = ''
endif

let b:undo_ftplugin .= 'setlocal shiftwidth< tabstop< softtabstop<'
