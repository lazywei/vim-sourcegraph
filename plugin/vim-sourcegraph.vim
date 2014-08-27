if !has('python')
  echo 'Error: Required vim compiled with +python'
  finish
endif

let s:debug = 0
let s:debug_file = 'vim-sourcegraph.log'

function! SrcDescribe()
  " python << EOF

  " import vim
  " from subprocess import Popen, PIPE
  " current_byte = vim.eval('line2byte(line("."))+col(".")')
  " current_buffer = vim.current.buffer.name

  " output, err = Popen(['src', 'api', 'describe',
  "                     '--file', current_buffer,
  "                     '--start-byte', current_byte],
  "                     stdin=PIPE, stdout=PIPE, stderr=PIPE).communicate()

  " output.decode('unicode_escape')
  " EOF
  call s:OpenWindow()
  call s:goto_win('p')
endfunction

" s:OpenWindow steal from Tagbar {{{
function! s:OpenWindow()
  let s:window_opening = 1
  let openpos = 'botright vertical '
  let src_width = 30
  exe 'silent keepalt ' . openpos . src_width . 'split ' . '__srclib__'
  unlet s:window_opening

  call append(line('$'), 'haha')

  setlocal filetype=srclib
  setlocal noreadonly " in case the "view" mode is used
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile
  setlocal nobuflisted
  setlocal nomodifiable
  setlocal nolist
  setlocal nowrap
  setlocal winfixwidth
  setlocal textwidth=0
  setlocal nospell

  setlocal nonumber

  setlocal nofoldenable
  setlocal foldcolumn=0
  " Reset fold settings in case a plugin set them globally to something
  " expensive. Apparently 'foldexpr' gets executed even if 'foldenable' is
  " off, and then for every appended line (like with :put).
  setlocal foldmethod&
  setlocal foldexpr&
endfunction
" }}}

" s:goto_win() {{{2
function! s:goto_win(winnr, ...) abort
  let cmd = type(a:winnr) == type(0) ? a:winnr . 'wincmd w'
        \ : 'wincmd ' . a:winnr
  let noauto = a:0 > 0 ? a:1 : 0

  call s:debug("goto_win(): " . cmd . ", " . noauto)

  if noauto
    noautocmd execute cmd
  else
    execute cmd
  endif
endfunction

" s:debug() {{{2
if has('reltime')
  function! s:gettime() abort
    let time = split(reltimestr(reltime()), '\.')
    return strftime('%Y-%m-%d %H:%M:%S.', time[0]) . time[1]
  endfunction
else
  function! s:gettime() abort
    return strftime('%Y-%m-%d %H:%M:%S')
  endfunction
endif
function! s:debug(msg) abort
  if s:debug
    execute 'redir >> ' . s:debug_file
    silent echon s:gettime() . ': ' . a:msg . "\n"
    redir END
  endif
endfunction
