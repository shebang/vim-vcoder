" pattern taken from Shougo's denite#custom#_init
function! vcoder#testrunner#_get() abort
  if !exists('s:testrunner')
    call vcoder#testrunner#init()
  endif
  return s:testrunner
endfunction

function! vcoder#testrunner#init() abort
  let s:testrunner = {}
  let s:testrunner.spec_defaults = {}
  let s:testrunner.registry = {}
endfunction

""
" Returns the target to execute (file or project). This function is dependant
" on the values of the following variables. Each may return a test target effectivly
" overwriting the defaults. Order is as follows
"
" * b:vcoder_target
" * g:vcoder_target
" * default: file
"
function! vcoder#testrunner#get_target(name, context) abort
  let default_target = 'file'
  let from = ''
  if exists('b:vcoder_target')
    let target = b:vcoder_target
    let from = 'buffer local'
  elseif exists('g:vcoder_target')
    let target = g:vcoder_target
    let from = 'global'
  endif
  if !empty(from)
    call vcoder#util#notify_user('using target ' . target . ' from ' . from . ' variable.')
    return target =~? '\m\c^\(file\|project\)$' ? target : default_target
  endif
  return default_target
endfunction

""
" Registers test runner {name} with vcoder
"
function! vcoder#testrunner#register(name) abort
  let registry = vcoder#testrunner#_get().registry
  if has_key(registry, a:name)
    return
  endif
  let spec_func = 'vcoder#testrunner#' . a:name . '#spec'
  let spec = call(spec_func, [])

  let registry[a:name] = spec
endfunction

function! vcoder#testrunner#is_installed(name) abort
  let registry = vcoder#testrunner#_get().registry
  if !has_key(registry, a:name)
    return 0
  endif
  let testrunner = registry[a:name]
  return testrunner.is_installed()
endfunction


function! vcoder#testrunner#install(name) abort
  let registry = vcoder#testrunner#_get().registry
  if !has_key(registry, a:name)
    echohl WarningMsg | echo "No such test runner: " . string(a:name) | echohl None
    return
  endif

  if vcoder#testrunner#is_installed(a:name)
    call vcoder#util#notify_user(a:name . ' already installed')
    return
  endif

  let testrunner = registry[a:name]
  call vcoder#testrunner#jobstart(testrunner.install_cmd, {'summary_only':1})
endfunction

""
" Runs a test described by {context} with test runner {name}.
"
function! vcoder#testrunner#run(name, context) abort
  let registry = vcoder#testrunner#_get().registry
  if !has_key(registry, a:name)
    echohl WarningMsg | echo "No such test runner: " . string(a:name) | echohl None
    return
  endif

  let testrunner = registry[a:name]
  let target = 'test_' . vcoder#testrunner#get_target(a:name, a:context)
  call vcoder#testrunner#jobstart(call(testrunner[target], [a:context]))
  " call vcoder#testrunner#jobstart(testrunner.test_file(a:context))
  " call vcoder#testrunner#jobstart(testrunner.test_project(a:context))
endfunction

function! s:build_command(cmd)
  if has('win32') || has('win64')
    let cmd = ['cmd', '/c'] + a:cmd
  else
    let cmd = ['bash', '-c'] + a:cmd
  endif
  return cmd
endfunction

function! s:stdout_handler(job_id, data, event_type) abort
  echo join(reverse(filter(a:data, 'v:val !=? ""')))
endfunction

function! s:stderr_handler(job_id, data, event_type) abort
  echom join(a:data)
endfunction

function! s:exit_handler(job_id, data, event_type) abort
  if a:data == 0
    call vcoder#util#notify_user('command completed successfuly')
  else
    echohl WarningMsg | echo '[vcoder] command exits with code ' . string(a:data) | echohl None
  endif
endfunction

function! s:stdout_handler_resultview(job_id, data, event_type) abort
  call vcoder#resultview#show(a:data)
endfunction

function! s:stderr_handler_resultview(job_id, data, event_type) abort
  call vcoder#resultview#show(a:data)
endfunction

function! s:exit_handler_resultview(job_id, data, event_type) abort
  " call vcoder#resultview#show(testrunner, out)
endfunction

"
" Starts a job from a test runner. Restults are displayed depending on
""
" opts.summary_only (see below).
"
" Options can be configured using [a:1] which is a |Dict| with the following
" settings:
"
" * opts.summary_only: v:false
"   Shows job status only via status line. The default is to show the results
"   via resultview.
"
function! vcoder#testrunner#jobstart(cmd, ...) abort
  let cmd = vcoder#util#convert2list(a:cmd)
  let defaults = {'summary_only': v:false}
  let opts = a:0 == 1 ? a:1 : {}
  let opts = extend(defaults, opts)

  let command = s:build_command([join(cmd)])

  if opts.summary_only
    let jobid = vcoder#job#start(command, {
      \ 'on_stdout': function('s:stdout_handler'),
      \ 'on_stderr': function('s:stderr_handler'),
      \ 'on_exit': function('s:exit_handler'),
      \ })
  else
    let jobid = vcoder#job#start(command, {
      \ 'on_stdout': function('s:stdout_handler_resultview'),
      \ 'on_stderr': function('s:stderr_handler_resultview'),
      \ 'on_exit': function('s:exit_handler_resultview'),
      \ })
  endif

  if jobid < 0
    echohl WarningMsg | echo '[vcoder] job failed to start' | echohl None
  endif

endfunction


