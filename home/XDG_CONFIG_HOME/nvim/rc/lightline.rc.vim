" hide mode
set noshowmode
" showtabline always
set showtabline=2

let g:lightline = {
      \   'mode_map': { 'c': 'NORMAL' },
      \   'active': {
      \     'left': [ [ 'mode', 'paste' ],
      \               [ 'branch', 'hunks' ],
      \               [ 'readonly', 'filename', 'modified' ] ],
      \     'right': [ [ 'percent', 'lineinfo' ],
      \                [ 'ale_ok', 'ale_info', 'filetype', 'fileencoding', 'denitepath' ],
      \                [ 'ale_linting', 'ale_warning', 'ale_error', 'tag' ] ],
      \   },
      \   'component_function': {
      \     'mode': 'MyLightlineMode',
      \     'hunks': 'MyLightlineHunks',
      \     'branch': 'MyLightlineBranch',
      \     'filename': 'MyLightlineFilename',
      \     'modified': 'MyLightlineModified',
      \     'tag': 'MyLightlineCurrentTag',
      \     'filetype': 'MyLightlineFiletype',
      \     'fileencoding': 'MyLightlineFileencoding',
      \     'denitepath': 'MyLightlineDenitepath',
      \     'percent': 'MyLightlinePercent',
      \     'lineinfo': 'MyLightlineLineinfo',
      \   },
      \   'component_expand': {
      \     'readonly': 'MyLightlineReadonly',
      \     'ale_error': 'MyLightlineAleError',
      \     'ale_warning': 'MyLightlineAleWarning',
      \     'ale_info': 'MyLightlineAleInfo',
      \     'ale_ok': 'MyLightlineAleOK',
      \     'ale_linting': 'MyLightlineAleLinting',
      \   },
      \   'component_type': {
      \     'readonly': 'warning',
      \     'ale_error': 'error',
      \     'ale_warning': 'warning',
      \     'ale_linting': 'warning',
      \   },
      \   'subseparator': {
      \     'left': '',
      \     'right': ''
      \   },
      \ }

" colorscheme
function! s:followColorScheme() abort
  if g:colors_name =~? 'deus\|dracula\|iceberg\|jellybeans\|molokai\|onedark\|seoul256\|solarized'
    let g:lightline.colorscheme=g:colors_name
  else
    let g:lightline.colorscheme='default'
  endif
  call lightline#init()
  call lightline#colorscheme()
endfunction

autocmd MyAutoCmd ColorScheme * call s:followColorScheme()

" autocmd for ALE
autocmd MyAutoCmd User ALEJobStarted call lightline#update()
autocmd MyAutoCmd User ALELintPost call lightline#update()
autocmd MyAutoCmd User ALEFixPost call lightline#update()

" functions
function! MyLightlineMode() abort
  if &filetype ==? 'denite'
    call lightline#link(tolower(denite#get_status('raw_mode')[0]))
    return 'Denite'
  endif
  if winwidth(0) <= 60
    return ''
  endif
  return lightline#mode()
endfunction

function! MyLightlineHunks() abort
  if winwidth(0) <= 100
        \ || !exists('*GitGutterGetHunkSummary')
        \ || !get(g:, 'gitgutter_enabled', 0)
    return ''
  endif
  let l:symbols = [
        \ g:gitgutter_sign_added,
        \ g:gitgutter_sign_modified,
        \ g:gitgutter_sign_removed
        \ ]
  let l:hunks = GitGutterGetHunkSummary()
  let l:ret = []
  for l:i in [0, 1, 2]
    if l:hunks[l:i]> 0
      call add(l:ret, l:symbols[l:i] . l:hunks[l:i])
    endif
  endfor
  return join(l:ret, ' ')
endfunction

function! MyLightlineBranch() abort
  if winwidth(0) <= 75 || !exists('*FugitiveHead')
    return ''
  endif
  return FugitiveHead()
endfunction

function! MyLightlineReadonly() abort
  return &filetype !~? 'help\|man\|denite' && &readonly ? 'RO' : ''
endfunction

function! MyLightlineFilename() abort
  " for linediff
  if exists('b:differ.description')
    return b:differ.description
  endif
  " for partedit
  if exists('b:partedit')
    return b:partedit.filename .
          \ '[' . b:partedit.firstline . '-' . b:partedit.lastline . ']'
  endif
  return (&filetype ==? 'denite' ? denite#get_status('sources') :
        \  &filetype =~? 'tagbar\|nerdtree' ? '' :
        \  &filetype =~? 'help\|man' ? expand('%:t') :
        \  winwidth(0) > 150 ? expand('%') :
        \  winwidth(0) > 110 ? pathshorten(expand('%')) :
        \ '' !=# expand('%:t') ? expand('%:t') :'[No Name]')
endfunction

function! MyLightlineModified() abort
  return &filetype =~? 'help\|man\|denite' ? '' :
        \ &modified ? '+' :
        \ &modifiable ? '' : '-'
endfunction

function! MyLightlineCurrentTag() abort
  if winwidth(0) <= 90
        \ || exists(':TagbarToggle') != 2
    return ''
  endif
  return tagbar#currenttag('%s','')
endfunction

function! MyLightlineAleError() abort
  if !s:aleLinted()
    return ''
  endif

  let l:counts = ale#statusline#Count(bufnr(''))
  let l:errors = l:counts.error + l:counts.style_error

  return l:errors ?  'E:' . l:errors : ''
endfunction

function! MyLightlineAleWarning() abort
  if !s:aleLinted()
    return ''
  endif

  let l:counts = ale#statusline#Count(bufnr(''))
  let l:warnings = l:counts.warning + l:counts.style_warning

  return l:warnings ? 'W:' .  l:warnings : ''
endfunction

function! MyLightlineAleInfo() abort
  if !s:aleLinted()
    return ''
  endif

  let l:counts = ale#statusline#Count(bufnr(''))
  let l:errors = l:counts.error + l:counts.style_error
  let l:warnings = l:counts.warning + l:counts.style_warning
  let l:infos = l:counts.total - l:errors - l:warnings

  return l:infos ? 'I:' . l:infos : ''
endfunction

function! MyLightlineAleOK() abort
  if !s:aleLinted()
    return ''
  endif

  let l:counts = ale#statusline#Count(bufnr(''))
  if l:counts.total > 0
    return ''
  endif

  return 'OK'
endfunction

function! MyLightlineAleLinting() abort
  if ale#engine#IsCheckingBuffer(bufnr('')) == 1
    return 'linting...'
  endif

  return ''
endfunction

function! s:aleLinted() abort
  return get(g:, 'ale_enabled', 0) == 1
    \ && getbufvar(bufnr(''), 'ale_linted', 0) > 0
    \ && ale#engine#IsCheckingBuffer(bufnr('')) == 0
endfunction

function! MyLightlineFiletype() abort
  if winwidth(0) <= 70 || &filetype ==? 'denite'
    return ''
  endif
  return &filetype
endfunction

function! MyLightlineFileencoding() abort
  if winwidth(0) <= 70 || &filetype ==? 'denite'
    return ''
  endif
  return (&fileencoding !=# '' ? &fileencoding : &encoding) .
        \ '[' . &fileformat . ']'
endfunction

function! MyLightlineDenitepath() abort
  if &filetype !=? 'denite'
    return ''
  endif
  return substitute(denite#get_status('path'), '^[' . $HOME, '[~', '')
endfunction

function! MyLightlinePercent() abort
  if &filetype ==? 'denite'
    let l:line_total = denite#get_status('line_total')
    if l:line_total[1] == 0
      return printf('%3d%%', 100)
    endif
    let l:line_cursor = denite#get_status('line_cursor')
    return printf('%3d%%', 100 * l:line_cursor / l:line_total)
  else
    return printf('%3d%%', 100 * line('.') / line('$'))
  endif
endfunction

function! MyLightlineLineinfo() abort
  return &filetype ==? 'denite' ? denite#get_status('linenr') :
        \ printf('%3d:%-2d', line('.'), col('.'))
endfunction

