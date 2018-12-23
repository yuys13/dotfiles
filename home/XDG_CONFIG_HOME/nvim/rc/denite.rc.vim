" for lightline
if exists('g:lightline')
  call denite#custom#option('_', 'statusline', v:false)
endif

" Change default prompt
call denite#custom#option('default', 'prompt', '>')
call denite#custom#option('help', 'prompt', 'help?')
call denite#custom#option('ft', 'prompt', 'set ft =')
call denite#custom#option('history', 'prompt', ':')
call denite#custom#option('cd', 'prompt', 'cd')
call denite#custom#option('line', 'prompt', '/')
call denite#custom#option('toggle', 'prompt', 'toggle')

" alias
call denite#custom#alias('source', 'file/rec/git', 'file/rec')
call denite#custom#var('file/rec/git', 'command',
      \ ['git', 'ls-files', '-co', '--exclude-standard'])

call denite#custom#alias('source', 'file/rec/gitignore', 'file/rec')
call denite#custom#var('file/rec/gitignore', 'command',
      \ ['git', 'ls-files', '-co', '--exclude-standard', '-i'])

call denite#custom#alias('source', 'file/rec/all', 'file/rec')

" file/rec
if executable('fd')
  call denite#custom#var('file/rec', 'command',
        \ ['fd', '--follow', '--color', 'never', '--type', 'f', ''])
  call denite#custom#var('directory_rec', 'command',
        \ ['fd', '--follow', '--color', 'never', '--type', 'd', ''])
elseif executable('ag')
  call denite#custom#var('file/rec', 'command',
        \ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
endif

" grep source
if executable('rg')
  call denite#custom#var('grep', 'command', ['rg'])
  call denite#custom#var('grep', 'default_opts',
        \ ['--vimgrep', '--no-heading'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])
endif

" Change mappings.
call denite#custom#map(
      \ 'insert',
      \ '<esc>',
      \ '<denite:enter_mode:normal>',
      \ 'noremap'
      \)
call denite#custom#map(
      \ 'normal',
      \ '<esc>',
      \ '<denite:quit>',
      \ 'noremap'
      \)

call denite#custom#map(
      \ 'insert',
      \ '<C-j>',
      \ '<denite:move_to_next_line>',
      \ 'noremap'
      \)
call denite#custom#map(
      \ 'insert',
      \ '<C-k>',
      \ '<denite:move_to_previous_line>',
      \ 'noremap'
      \)

call denite#custom#map(
      \ 'insert',
      \ '<C-t>',
      \ '<denite:do_action:tabopen>',
      \ 'noremap'
      \)

" Add custom menus
let s:menus = {}

let s:menus.toggle = {
      \ 'description': 'toggle plugin/option'
      \ }
let s:menus.toggle.command_candidates = [
      \ ['tagbar', 'TagbarToggle'],
      \ ['nerdtree', 'NERDTreeToggle'],
      \ ['indentLine', 'IndentLinesToggle'],
      \ ['TableMode', 'TableModeToggle'],
      \ ['ale', 'ALEToggle'],
      \ ['wrap', 'set wrap!'],
      \ ['expandtab', 'set expandtab!'],
      \ ['relativenumber', 'set relativenumber!'],
      \ ['cursorcolumn', 'set cursorcolumn!'],
      \]

call denite#custom#var('menu', 'menus', s:menus)

