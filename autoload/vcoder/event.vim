function! vcoder#event#init() abort

  augroup vcoder_context_handler
    autocmd!
    autocmd BufRead * call vcoder#context#update()
    autocmd FileType * call vcoder#context#set_filetype()
  augroup END

  call s:register_autocmds()

endfunction

function! s:create_autocmd(ft) abort
  execute 'augroup vcoder_eventhandler_'.a:ft
  execute 'autocmd!'
  " FIXME not always true
  execute 'autocmd BufWritePost *.'.a:ft . ' if vcoder#is_enabled("'.a:ft.'") | call vcoder#event#dispatch("'.a:ft.'") | endif'
  execute 'augroup END'
endfunction

function! s:register_autocmds() abort

  for ft in vcoder#enabled_ft()
    call s:create_autocmd(ft)
  endfor

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


