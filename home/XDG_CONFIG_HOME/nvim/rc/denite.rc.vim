" Change default prompt
call denite#custom#option('default', 'prompt', '>')
call denite#custom#option('help', 'prompt', 'help?')
call denite#custom#option('ft', 'prompt', 'set ft =')
call denite#custom#option('history', 'prompt', ':')
call denite#custom#option('cd', 'prompt', 'cd')
call denite#custom#option('line', 'prompt', '/')
call denite#custom#option('toggle', 'prompt', 'toggle')

" alias
call denite#custom#alias('source', 'file_rec/git', 'file_rec')
call denite#custom#var('file_rec/git', 'command',
      \ ['git', 'ls-files', '-co', '--exclude-standard'])

call denite#custom#alias('source', 'file_rec/gitignore', 'file_rec')
call denite#custom#var('file_rec/gitignore', 'command',
      \ ['git', 'ls-files', '-co', '--exclude-standard', '-i'])

call denite#custom#alias('source', 'file_rec/all', 'file_rec')

" file_rec
if executable('ag')
  call denite#custom#var('file_rec', 'command',
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
      \ ['ale', 'ALEToggle'],
      \ ['wrap', 'set wrap! wrap?'],
      \ ['expandtab', 'set expandtab! wrap?'],
      \]

call denite#custom#var('menu', 'menus', s:menus)
