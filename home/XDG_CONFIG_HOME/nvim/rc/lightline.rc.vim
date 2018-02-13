" showtabline always
set showtabline=2

let g:lightline = {
      \   'colorscheme': 'solarized',
      \   'mode_map': { 'c': 'NORMAL' },
      \   'active': {
      \     'left': [ [ 'mode', 'paste' ],
      \               [ 'hunks', 'fugitive' ],
      \               [ 'readonly', 'filename', 'modified' ] ],
      \     'right': [ [ 'percent', 'lineinfo' ],
      \                [ 'filetype', 'fileencoding', 'denitepath' ],
      \                [ 'ale_warning', 'ale_error', 'tag' ] ],
      \   },
      \   'component_function': {
      \     'mode': 'MyLightlineMode',
      \     'modified': 'MyLightlineModified',
      \     'readonly': 'MyLightlineReadonly',
      \     'filename': 'MyLightlineFilename',
      \     'fugitive': 'MyLightlineBranch',
      \     'hunks': 'MyLightlineHunks',
      \     'filetype': 'MyLightlineFiletype',
      \     'fileencoding': 'MyLightlineFileencoding',
      \     'denitepath': 'MyLightlineDenitepath',
      \     'tag': 'MyLightlineCurrentTag',
      \     'percent': 'MyLightlinePercent',
      \     'lineinfo': 'MyLightlineLineinfo'
      \   },
      \   'component_expand': {
      \     'readonly': 'MyLightlineReadonly',
      \     'ale_error': 'MyLightlineAleError',
      \     'ale_warning': 'MyLightlineAleWarning',
      \     'ale_info': 'MyLightlineAleInfo',
      \   },
      \   'component_type': {
      \     'readonly': 'warning',
      \     'ale_error': 'error',
      \     'ale_warning': 'warning',
      \   },
      \   'subseparator': {
      \     'left': '',
      \     'right': ''
      \   },
      \ }

" autocmd for ALE
autocmd MyAutoCmd User ALELint call lightline#update()
autocmd MyAutoCmd User ALELintPre call MyLightlineAlePre()
autocmd MyAutoCmd User ALELintPost call MyLightlineAlePost()

" functions
function! MyLightlineModified() abort
  return &filetype =~? 'help\|man\|denite' ? '' :
        \ &modified ? '+' :
        \ &modifiable ? '' : '-'
endfunction

function! MyLightlineReadonly() abort
  return &filetype !~? 'help\|man\|denite' && &readonly ? 'RO' : ''
endfunction

function! MyLightlineFilename() abort
  return (&filetype ==? 'denite' ? denite#get_status('sources') :
        \  &filetype =~? 'tagbar\|nerdtree' ? '' :
        \  &filetype =~? 'help\|man' ? expand('%:t') :
        \  winwidth(0) > 150 ? expand('%') :
        \  winwidth(0) > 110 ? pathshorten(expand('%')) :
        \ '' !=# expand('%:t') ? expand('%:t') :'[No Name]')
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
  if winwidth(0) <= 75 || !exists('*fugitive#head')
    return ''
  endif
  return fugitive#head()
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
  return denite#get_status('path')
endfunction

function! MyLightlineMode() abort
  if &filetype ==? 'denite'
    let l:mode = substitute(denite#get_status('mode'), '[ -]*', '', 'g')
    call lightline#link(tolower(l:mode[0]))
    return 'Denite'
  endif
  if winwidth(0) <= 60
    return ''
  endif
  return lightline#mode()
endfunction

function! MyLightlineCurrentTag() abort
  if winwidth(0) <= 90
        \ || exists(':TagbarToggle') != 2
    return ''
  endif
  return tagbar#currenttag('%s','')
endfunction

function! MyLightlineAleError() abort
  return s:lightlineAle(0)
endfunction

function! MyLightlineAleWarning() abort
  return s:lightlineAle(1)
endfunction

function! MyLightlineAleInfo() abort
  return s:lightlineAle(2)
endfunction

let s:ale_running = 0

function! MyLightlineAlePre() abort
  let s:ale_running = 1
  call lightline#update()
endfunction

function! MyLightlineAlePost() abort
  let s:ale_running = 0
  call lightline#update()
endfunction

function! s:lightlineAle(mode)
  if !exists('g:ale_buffer_info') || &filetype ==? 'denite'
    return ''
  endif
  if s:ale_running
    " it shows an icon in linting with the `warning` color.
    return a:mode == 1 ? 'linting...' : ''
  endif

  let l:buffer = bufnr('%')
  let l:counts = ale#statusline#Count(l:buffer)

  if a:mode == 0 " Error
    let l:errors = l:counts.error + l:counts.style_error
    return l:errors ?  'E:' . l:errors : ''
  elseif a:mode == 1 " Warning
    let l:warnings = l:counts.warning + l:counts.style_warning
    return l:warnings ? 'W:' .  l:warnings : ''
  endif

  return l:counts.total ? '' : 'OK'
endfunction

function! MyLightlineLineinfo() abort
  return &filetype ==? 'denite' ? denite#get_status('linenr') :
        \ printf('%3d:%-2d', line('.'), col('.'))
endfunction

function! MyLightlinePercent() abort
  if &filetype ==? 'denite'
    let l:nr = split(substitute(denite#get_status('linenr'), ' ', '', 'g'), '/')
    return printf('%3d%%', 100 * l:nr[0] / l:nr[1])
  else
    return printf('%3d%%', 100 * line('.') / line('$'))
  endif
endfunction
