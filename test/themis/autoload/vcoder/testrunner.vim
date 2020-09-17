let s:suite = themis#suite('vcoder_testrunner')
let s:scope = themis#helper('scope')
let s:assert = themis#helper('assert')


function! s:suite.before_each() abort

endfunction

function! s:suite.test_register() abort

  call vcoder#testrunner#register('themis')
  call s:assert.equal(vcoder#testrunner#_get().registry['themis'].name, 'themis')
endfunction

function! s:suite.test_register_test_runner_twice_is_ignored() abort

  call vcoder#testrunner#register('themis')
  call s:assert.equal(vcoder#testrunner#_get().registry['themis'].name, 'themis')
  call s:assert.equal(len(vcoder#testrunner#_get().registry), 1)
endfunction

function! s:suite.test_jobstart() abort
  let result = vcoder#testrunner#jobstart(['echo "test"'])
  " call s:assert.equal(v:statusmsg,1)
endfunction


