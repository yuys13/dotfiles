" showtabline always
set showtabline=2

let g:lightline = {
      \   'colorscheme': 'solarized',
      \   'mode_map': { 'c': 'NORMAL' },
      \   'active': {
      \     'left': [ [ 'mode', 'paste' ],
      \               [ 'hunks', 'fugitive' ],
      \               [ 'readonly', 'filepath', 'filename', 'modified' ] ],
      \     'right': [ [ 'percent', 'lineinfo' ],
      \                [ 'filetype', 'fileencoding' ],
      \                [ 'ale_warning', 'ale_error', 'tag' ] ],
      \   },
      \   'component_function': {
      \     'mode': 'MyLightlineMode',
      \     'modified': 'MyLightlineModified',
      \     'readonly': 'MyLightlineReadonly',
      \     'filepath': 'MyLightlineFilepath',
      \     'filename': 'MyLightlineFilename',
      \     'fugitive': 'MyLightlineBranch',
      \     'hunks': 'MyLightlineHunks',
      \     'fileformat': 'MyLightlineFileformat',
      \     'filetype': 'MyLightlineFiletype',
      \     'fileencoding': 'MyLightlineFileencoding',
      \     'tag': 'MyLightlineCurrentTag'
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
function! MyLightlineModified()
  return &filetype =~? 'help\|man' ? '' :
        \ &modified ? '+' :
        \ &modifiable ? '' : '-'
endfunction

function! MyLightlineReadonly()
  return &filetype !~? 'help\|man' && &readonly ? 'RO' : ''
endfunction

function! MyLightlineFilepath()
  if winwidth(0) <= 150
        \ || expand('%:h') ==# '.' || expand('%:h') ==# ''
        \ || &filetype =~? 'help\|man'
    return ''
  endif
  return expand('%:h') . '/'
endfunction

function! MyLightlineFilename()
  return (&filetype ==? 'vimfiler' ? vimfiler#get_status_string() :
        \  &filetype ==? 'unite' ? unite#get_status_string() :
        \  &filetype ==? 'vimshell' ? vimshell#get_status_string() :
        \  &filetype ==? 'tagbar' ? '' :
        \  &filetype ==? 'nerdtree' ? '' :
        \ '' !=# expand('%:t') ? expand('%:t') :'[No Name]')
endfunction

function! MyLightlineHunks()
  if winwidth(0) <= 150
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

function! MyLightlineBranch()
  if winwidth(0) <= 75 || !exists('*fugitive#head')
    return ''
  endif
  return fugitive#head()
endfunction

function! MyLightlineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! MyLightlineFiletype()
  return winwidth(0) > 70 ? &filetype : ''
endfunction

function! MyLightlineFileencoding()
  if winwidth(0) <= 70
    return ''
  endif
  return (&fileencoding !=# '' ? &fileencoding : &encoding) .
        \ '[' . &fileformat . ']'
endfunction

function! MyLightlineMode()
  if winwidth(0) <= 60
    return ''
  endif
  return lightline#mode()
endfunction

function! MyLightlineCurrentTag()
  if winwidth(0) <= 100
        \ || exists(':TagbarToggle') != 2
    return ''
  endif
  return tagbar#currenttag('%s','')
endfunction

function! MyLightlineAleError()
  return s:lightlineAle(0)
endfunction

function! MyLightlineAleWarning()
  return s:lightlineAle(1)
endfunction

function! MyLightlineAleInfo()
  return s:lightlineAle(2)
endfunction

let s:ale_running = 0

function! MyLightlineAlePre()
  let s:ale_running = 1
  call lightline#update()
endfunction

function! MyLightlineAlePost()
  let s:ale_running = 0
  call lightline#update()
endfunction

function! s:lightlineAle(mode)
  if !exists('g:ale_buffer_info') || &filetype ==# 'denite'
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
