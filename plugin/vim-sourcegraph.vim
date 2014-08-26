if !has('python')
  echo 'Error: Required vim compiled with +python'
  finish
endif

function! SrcDescribe()
python << EOF

import vim
(row, col) = vim.current.window.cursor
print row
print col
print vim.eval('line2byte(line("."))+col(".")')
EOF
endfunction
