let s:suite = themis#suite('vcoder_context')
let s:scope = themis#helper('scope')
let s:assert = themis#helper('assert')


function! s:suite.before_each() abort

endfunction


function! s:suite.test_context() abort


  call s:assert.equal(1,1)
endfunction
