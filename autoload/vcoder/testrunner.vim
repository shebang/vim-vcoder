let s:V = vital#vcoder#new()
let s:Promise = s:V.import('Async.Promise')

function! vcoder#testrunner#run(testrunner) abort
  return call(a:testrunner.run_file, [a:testrunner])
endfunction


