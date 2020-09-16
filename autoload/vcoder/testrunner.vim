function! vcoder#testrunner#init() abort

  for testrunner in vcoder#rules#testrunners()
    let func = 'vcoder#testrunner#' . testrunner . '#init'
    let runner = call(func, [])
    if has_key(runner, 'build_cmd') && !runner.is_deployed()
      call vcoder#testrunner#jobstart([join(runner.build_cmd)])
    endif
  endfor
endfunction

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
  call vcoder#resultview#show(a:data)
endfunction

function! s:stderr_handler(job_id, data, event_type) abort
  " call vcoder#resultview#show(testrunner, out)
  call vcoder#resultview#show(a:data)
endfunction

function! s:exit_handler(job_id, data, event_type) abort
  " call vcoder#resultview#show(testrunner, out)
endfunction


function! vcoder#testrunner#jobstart(cmd, ...) abort
  let command = s:build_command(a:cmd)
  let jobid = vcoder#job#start(command, {
    \ 'on_stdout': function('s:stdout_handler'),
    \ 'on_stderr': function('s:stderr_handler'),
    \ 'on_exit': function('s:exit_handler'),
    \ })

  if jobid > 0
    " verbose echom 'job started'
  else
    " verbose echom 'job failed to start'
  endif

endfunction


