let s:V = vital#vcoder#new()
let s:Promise = s:V.import('Async.Promise')

" {{{1: Interface
" ============================================================================

function! vcoder#testrunner#themis#init(context) abort

  let s:themis = {}
  let s:themis.path_repo = vcoder#cache_path() . '/vim-themis'
  let s:themis.cmd = vcoder#cache_path() . '/vim-themis/bin/themis'
  let s:themis.args = []
  let s:themis.context = a:context
  let s:themis.run_file = function('s:themis_run_file')
  call s:init()

  return s:themis
endfunction

" runs all tests for the project
function! vcoder#testrunner#themis#run(...) abort

endfunction


" runs file test
function! vcoder#testrunner#themis#run_file(...) abort

endfunction

" {{{1: Implementation
" ============================================================================

function! s:read(chan, part) abort
  let out = []
  while ch_status(a:chan, {'part' : a:part}) =~# 'open\|buffered'
    call add(out, ch_read(a:chan, {'part' : a:part}))
  endwhile
  return join(out, "\n")
endfunction


function! s:themis_run_file_async(testrunner) abort
  let cmd = [a:testrunner.cmd] + a:testrunner.args + [a:testrunner.context.test_candidate]

  "FIXME: exit code > 0 means test case error but how ro detect other errors?
  return s:Promise.new({resolve, reject -> job_start(cmd, {
    \   'drop' : 'never',
    \   'close_cb' : {ch -> 'do nothing'},
    \   'exit_cb' : {ch, code -> resolve(s:read(ch, 'out'))
    \   },
    \ })})
endfunction

" runs file test
function! s:themis_run_file(testrunner) abort

  if has_key(a:testrunner.context, 'test_candidate')
    return s:themis_run_file_async(a:testrunner)
  endif
endfunction

function! s:themis_deploy() abort
  let cmd = 'git clone https://github.com/thinca/vim-themis '. vcoder#cache_path() . '/vim-themis'
  call system(cmd)
endfunction

function! s:check_themis() abort
  function s:themis_async_check()
    if ! isdirectory(s:themis.path_repo)
      call mkdir(s:themis.path_repo, 'p')
    endif

    if ! filereadable(s:themis.cmd)
      call s:themis_deploy()
    endif
  endfunction
  return s:Promise.new({resolve -> s:themis_async_check()})

endfunction

function! s:init() abort

  " call s:check_themis().then({-> execute('verbose echom "themis updated"', '')})
endfunction


