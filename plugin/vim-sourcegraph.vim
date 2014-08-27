if !has('python')
  echo 'Error: Required vim compiled with +python'
  finish
endif

function! SrcDescribe()
python << EOF

import vim
from subprocess import Popen, PIPE
current_byte = vim.eval('line2byte(line("."))+col(".")')
current_buffer = vim.current.buffer.name

output, err = Popen(['src', 'api', 'describe',
                    '--file', current_buffer,
                    '--start-byte', current_byte],
                    stdin=PIPE, stdout=PIPE, stderr=PIPE).communicate()

output.decode('unicode_escape')
EOF
call s:OpenWindow()
endfunction

" s:OpenWindow steal from Tagbar {{{
function! s:OpenWindow()
  let s:window_opening = 1
  let openpos = 'botright vertical '
  let src_width = 30
  exe 'silent keepalt ' . openpos . src_width . 'split ' . '__srclib__'
  unlet s:window_opening

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
