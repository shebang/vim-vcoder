let s:suite = themis#suite('vcoder_testrunner_themis')
let s:scope = themis#helper('scope')
let s:assert = themis#helper('assert')

function! s:suite.before_each() abort

endfunction


"FIXME: should not be run here
function! s:suite.test_install() abort
  let themis_dir = $HOME . '/.cache/vcoder/vim-themis'
  " FIXME: danger!
  call system('rm -fr '.themis_dir)
  let result = vcoder#testrunner#install('themis')
  call themis#log('waiting 5s for installation to complete')
  5sleep
  call s:assert.equal(filereadable(themis_dir . '/bin/themis'),1)
endfunction

function! s:suite.test_run_file() abort

  call vcoder#testrunner#register('themis')

endfunction
