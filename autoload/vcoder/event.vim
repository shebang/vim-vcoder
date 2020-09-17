
if !exists('s:event')
  let s:event = {}
  let s:event.enabled_ft = []
endif

function! s:delete_autocmd(ft) abort

endfunction

function! s:create_autocmd(ft) abort
  execute 'augroup vcoder_eventhandler_'.a:ft
  execute 'autocmd!'
  " FIXME not always true
  execute 'autocmd BufWritePost *.'.a:ft . ' if vcoder#is_enabled("'.a:ft.'") | call vcoder#event#dispatch("'.a:ft.'") | endif'
  execute 'augroup END'
endfunction

function! vcoder#event#_enable(ft_or_list) abort
  let ft_list = vcoder#util#convert2list(a:ft_or_list)

  for ft in ft_list
    if index(s:event.enabled_ft, ft) < 0
      call add(s:event.enabled_ft, ft)
      call vcoder#event#_enable_ft(ft)
    endif
  endfor
endfunction

function! vcoder#event#_disable(ft_or_list) abort
  let ft_list = vcoder#util#convert2list(a:ft_or_list)

  for ft in ft_list
    call remove(s:event.enabled_ft, index(s:event.enabled_ft, ft))
    call s:delete_autocmd(ft)
  endfor
endfunction

function! vcoder#event#_enabled_ft() abort
  return s:event.enabled_ft
endfunction

function! vcoder#event#_is_enabled(ft) abort
  return index(s:event.enabled_ft, a:ft) >= 0 ? 1 : 0
endfunction

function! vcoder#event#_enable_ft(ft) abort
  call s:create_autocmd(a:ft)
  call vcoder#context#set_filetype()
  call vcoder#context#update()
endfunction


function! vcoder#event#dispatch(...) abort
  let ft = a:0 == 1 ? a:1 : ''

  let path_file = expand('%:p')
  if !has_key(vcoder#context#get().buffers, path_file)
    return
  endif

  let context = vcoder#context#get().buffers[path_file]
  if !empty(context.test_candidate)
    call vcoder#testrunner#run(context)
  endif
endfunction


