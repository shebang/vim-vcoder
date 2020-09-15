let s:V = vital#vcoder#new()
let s:Promise = s:V.import('Async.Promise')

function! vcoder#testrunner#run(testrunner) abort
  " return s:Promise.new({resolve -> timer_start(5000, resolve)})
  return call(a:testrunner.run_file, [a:testrunner])
endfunction


function! vcoder#testrunner#show_result(testrunner, out) abort
  verbose echom '>>>>>>>> vcoder test result <<<<<<<<'
  for line in split(a:out, '\n')
    verbose echom '>>>: '.line
  endfor

endfunction
