""
" Replace all placeholders in {a:text} with values from dict {a:values}.
" Placeholders are wrapped with %-chars. Each placeholder has a corresponding
" key in the values dict.
function! vcoder#util#resolve_placeholders(text, values, ...) abort
  let text = a:text
  let wrap_char = a:0 == 1 ? a:1 : '%'

  for placeholder in keys(a:values)
    let regex = wrap_char . placeholder . wrap_char
    if text =~? regex
      let text = substitute(text, regex, a:values[placeholder], 'g')
    endif
  endfor
  return text

endfunction

" from: autoload/deoplete/util.vim
function! vcoder#util#convert2list(expr) abort
  return type(a:expr) ==# v:t_list ? a:expr : [a:expr]
endfunction
