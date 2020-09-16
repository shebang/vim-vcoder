let s:suite = themis#suite('vcoder_testrunner_themis')
let s:scope = themis#helper('scope')
let s:assert = themis#helper('assert')

function! s:suite.before_each() abort

endfunction


function! s:suite.test_run_file() abort

  " let source_file = expand('~/.cache/vcoder/test/vcoder-test.vim/autoload/vcoder_test.vim')
  " let result = execute('edit '.source_file)
  " let context = values(vcoder#context#get().buffers)[0]

  " let testrunner = vcoder#context#get_testrunner(context)
  " let s:callback_then = { testrunner, out -> s:assert.equal() }
  " verbose echom '!!!!!!!!!!!!!!!!! '
  " verbose echom testrunner
  " call vcoder#testrunner#run(testrunner)
  "   \.then({out -> execute('echom "Out: " . out', '')})
  "   \.catch({err -> execute('echom "Error: " . err', '')})



endfunction
