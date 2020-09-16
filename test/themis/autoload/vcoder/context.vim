let s:suite = themis#suite('vcoder_context')
let s:scope = themis#helper('scope')
let s:assert = themis#helper('assert')

let s:script_file = fnamemodify(expand('<sfile>'), ':p:h:h:h:h:h:h')

function! s:suite.before_each() abort
endfunction

function! s:suite.test_project_root_returns_a_valid_directory() abort

  call s:assert.not_empty(vcoder#context#project_root('vim'))
  call s:assert.equal(isdirectory(vcoder#context#project_root('vim')), 1)
endfunction

function! s:suite.test_context_get() abort

  let source_file = expand('~/.cache/vcoder/test/vcoder-test.vim/autoload/vcoder_test.vim')
  let result = execute('edit '.source_file)
  let context = values(vcoder#context#get().buffers)[0]
  call s:assert.has_key(context, 'ft')
  call s:assert.equal(context.ft, 'vim')
  call s:assert.equal(context.file_name, 'vcoder_test.vim')
  call s:assert.equal(context.file_project_dir, 'autoload')
  call s:assert.match(context.test_candidate, '^.*\/.cache/vcoder/test/vcoder-test.vim/test/themis/autoload/vcoder_test.vim')
  call s:assert.match(context.project_root, '^.*\/.cache\/vcoder\/test\/vcoder-test.vim')
endfunction



