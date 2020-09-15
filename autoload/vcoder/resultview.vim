function! vcoder#resultview#show(testrunner, result) abort
  let result = split(a:result, '\n')
  " verbose echom result
  if !empty(result)
    " let result = ['>>>>>>>> vcoder test result <<<<<<<<'] + result
    call vcoder#resultview#previewwindow#display_lines(result)
  endif
endfunction
