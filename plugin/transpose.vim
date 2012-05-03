" Vim transposition plugin.
" Plugin author: Benoit Mortgat
" Main git repository: http://github.com/salsifis/vim-transpose

if exists('s:transpose_plugin_loaded')
  finish
endif
let s:transpose_plugin_loaded = 1

if !exists('g:transpose_keepindent')
  let g:transpose_keepindent = 1
endif

command -range=% -nargs=0 Transpose
      \ call transpose#block  (<line1>, <line2>)

command -range=% -nargs=? TransposeWords
      \ call transpose#words  (<line1>, <line2>, <f-args>)

command -range=% -nargs=0 TransposeTab
      \ call transpose#tab    (<line1>, <line2>)

command -range=% -nargs=* TransposeCSV
      \ call transpose#csv    (<line1>, <line2>, <f-args>)

command -range=% -nargs=0 TransposeInteractive
      \ call transpose#interactive(<line1>, <line2>)

command -nargs=0 TransposeIndentToggle
      \ let g:transpose_keepindent = 1 - g:transpose_keepindent

" vim: ts=2 sw=2 et tw=80 colorcolumn=+1
