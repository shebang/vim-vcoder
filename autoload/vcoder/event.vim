let s:V = vital#vcoder#new()
let s:Promise = s:V.import('Async.Promise')

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


function! vcoder#event#dispatch(ft) abort

  if !has_key(vcoder#context#get().buffers, expand('%:p'))
    return
  endif

  let context = vcoder#context#get().buffers[expand('%:p')]
  let testrunner = vcoder#context#get_testrunner(context)

  ""FIXME: the testrunner should decide what to do: run single test, run all
  ""tests
  call vcoder#testrunner#run(testrunner)
    \.then({out -> vcoder#resultview#show(testrunner, out)})
    \.catch({err -> execute('echom "Error: " . err', '')})

endfunction


