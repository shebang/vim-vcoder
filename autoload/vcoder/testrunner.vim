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

  for testrunner in vcoder#rules#testrunners()
    let func = 'vcoder#testrunner#' . testrunner . '#init'
    let runner = call(func, [])
    if has_key(runner, 'build_cmd') && !runner.is_deployed()
      call vcoder#testrunner#jobstart([join(runner.build_cmd)])
    endif
  endfor
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

function! vcoder#testrunner#install(name) abort
  let registry = vcoder#testrunner#_get().registry
  if !has_key(registry, a:name)
    echohl WarningMsg | echo "No such test runner: " . string(a:name) | echohl None
    return
  endif
  let testrunner = registry[a:name]
  let cmd = [join(testrunner.install_cmd)]
  verbose echom 'exec: '.string(cmd)
  let job = vcoder#testrunner#jobstart(cmd,
    \ {'summary_only': v:true})
  " verbose echom testrunner
endfunction

""
" Runs a test by delegating the work to the approriate test runner.
"
function! vcoder#testrunner#run(context) abort
  call call(a:context.testrunner, [a:context])
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
    echo '[vcoder] command completed successfuly'
  else
    echohl WarningMsg | echo '[vcoder] command exits with code ' . string(a:data) | echohl None
  endif
endfunction

function! s:stdout_handler_resultview(job_id, data, event_type) abort
  call vcoder#resultview#show(a:data)
endfunction

function! s:stderr_handler_resultview(job_id, data, event_type) abort
  " call vcoder#resultview#show(testrunner, out)
  call vcoder#resultview#show(a:data)
endfunction

function! s:exit_handler_resultview(job_id, data, event_type) abort
  " call vcoder#resultview#show(testrunner, out)
endfunction

"
""
" Starts a job from a test runner. Restults are displayed depending on
" opts.notify (see below).
"
" Options can be configured using [a:1] which is a |Dict| with the following
" settings:
"
" * opts.summary_only: v:false
"   Shows job status only via status line. The default is to show the results
"   via resultview.
"
function! vcoder#testrunner#jobstart(cmd, ...) abort
  let defaults = {'summary_only': v:false}
  let opts = a:0 == 1 ? a:1 : {}
  let opts = extend(defaults, opts)

  let command = s:build_command(a:cmd)

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


