function! vcoder#resultview#show(result) abort
  if type(a:result) == v:t_list
    " if has('nvim')
    "   let result = split(join(a:result, ''), '\r')
    "   " let result = a:result
    " else
    " endif
    let result = split(join(a:result, ''), '\r')
    if !empty(result)
      call vcoder#resultview#previewwindow#display_lines(result)
    endif
  endif
endfunction
