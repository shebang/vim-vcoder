function! vcoder#resultview#show(testrunner, result) abort
  let result = split(a:result, '\n')
  if !empty(result)
    call vcoder#resultview#previewwindow#display_lines(result)
  endif
endfunction
