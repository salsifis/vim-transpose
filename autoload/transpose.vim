" Vim transposition plugin.
" Plugin author: Benoit Mortgat
" Main git repository: http://github.com/salsifis/vim-transpose

" == Main function ==
"
" * first_line , last_line  | range of lines on which to operate
" * isp                     | Input separator pattern (tokenizes input lines)
"                           | This is a Vim pattern.
" * ofs                     | Output field separator
" * dfv                     | Default field value when transposed data has not
"                           | The same number of fields on each line
function transpose#t(first_line, last_line, isp, ofs, dfv)
  let input_lines = getline(a:first_line, a:last_line)

  let indentation = 0
  if exists('g:transpose_keepindent') && g:transpose_keepindent > 0
      let indentation = min(map(copy(input_lines), 'match(v:val,"[^ ]")'))
      if indentation > 0
        call map(input_lines, 'v:val['.indentation.':]')
      endif
  endif

  " Split each line into fields according to the input pattern separator
  let tokenized_lines = map( input_lines, 'split(v:val, a:isp, 1)')

  " Delete input lines from buffer, to the black hole register
  silent! execute a:first_line . ',' . a:last_line . 'd _'

  let nb_output_lines = max(map(copy(tokenized_lines), 'len(v:val)'))

  " For each output line (line i) take i^th field of each input line. If it does
  " not exist, take default value.
  for i in range(0, nb_output_lines - 1)
    call append( a:first_line - 1 + i
    \          , repeat(' ', indentation)
    \          . join( map(copy(tokenized_lines)
    \                     ,'(i < len(v:val)) ? v:val[i] : a:dfv'
    \                     )
    \                , a:ofs
    \                )
    \          )
  endfor
endfunction

" == Specialized function: Array of characters ==
function transpose#block(first_line, last_line)
  " Input separator pattern: any zero-width match between two chars => .\zs\ze.
  " Output separator: empty
  " Default field value: a space.
  call transpose#t(a:first_line, a:last_line, '.\zs\ze.', '', ' ')
endfunction

" == Specialized function: Words (separated by whitespace)
function transpose#words(first_line, last_line, ...)
  " If an argument is provided, this is the default field value
  if a:0 > 1
    throw 'Only one additional argument allowed (default field value)'
  endif
  let dfv = (a:0 > 0) ? a:1 : '?'
  " Input separator pattern: whitespace
  " Output separator: one space
  " Default field value: nonempty.
  call transpose#t(a:first_line, a:last_line, '\s\+', ' ', dfv)
endfunction

" == Specialized function: Tabs (separated by tabulation character)
function transpose#tab(first_line, last_line)
  " Input separator pattern: single tab
  " Output separator: tab
  " Default field value: empty
  call transpose#t(a:first_line, a:last_line, "\x09", "\x09", '')
endfunction

" == Specialized function: Separated fields ==
" There are two special sequences of characters in the input:
" * The separator (typically semicolon)
" * The delimiter; when fields contain the separator their contents can be
"   surrounded with two delimiters. If they must contain the delimiter itself,
"   it has to be doubled.
"   If the delimiter is empty, then no field can contain the separator.
"
" Example: Separator and delimiter being resp ; and '
" 'a;b';c;'d;e''f'
" Contains three fields : a;b |  c | d;e'f
function transpose#delimited(first_line, last_line, separator, delimiter)
  let separator = escape(a:separator          , '\*[].^$')
  let delimiter = escape(a:delimiter, '\*[].^$')
  if delimiter !=# ''
    let isp = '\%('
    \       . delimiter
    \       . '\%([^' . delimiter . ']\|' . delimiter . delimiter . '\)*'
    \       . delimiter . '\%('  . delimiter . '\)\@!'
    \       . '\|[^' . separator.delimiter . ']*\)\zs' . separator
  else
    let isp = separator
  endif
  let ofs = a:separator
  let placeholder = ''
  call transpose#t(a:first_line, a:last_line, isp, ofs, placeholder)
endfunction

" == Specialized function: CSV input ==
" Calls the previous function, with variable number of arguments. Number of
" additional arguments shall not exceed 2.
" 1st argument: separator, default is semicolon
" 2nd argument: delimiter, default is none.
function transpose#csv(first_line, last_line, ...)
  if a:0 > 2
    throw 'Optional arguments: separator, delimiter. Only 2 allowed.'
  endif
  let separator = (a:0 > 0) ? a:1 : ';'
  let delimiter = (a:0 > 1) ? a:2 : ''
  call transpose#delimited(a:first_line, a:last_line, separator, delimiter)
endfunction

" == Interactive way ==
" Asks for parameters
function transpose#interactive(first_line, last_line)
  let isp = input('What Vim pattern separates input fields? ')
  let ofs = input('What string will join fields in output? ')
  let dfv = input('What is default field value? ')
  call transpose#t(a:first_line, a:last_line, isp, ofs, dfv)
endfunction

" vim: ts=2 sw=2 et tw=80 colorcolumn=+1
