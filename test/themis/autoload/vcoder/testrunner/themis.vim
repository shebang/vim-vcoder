let s:suite = themis#suite('vcoder_testrunner_themis')
let s:scope = themis#helper('scope')
let s:assert = themis#helper('assert')

function! s:suite.before_each() abort

endfunction


function! s:suite.test_run_file() abort

  call vcoder#testrunner#register('themis')

endfunction
