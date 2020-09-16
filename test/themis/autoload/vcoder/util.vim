let s:suite = themis#suite('vcoder_util')
let s:scope = themis#helper('scope')
let s:assert = themis#helper('assert')

function! s:suite.before_each() abort

endfunction

function! s:suite.test_resolve_placeholders_replaces_placeholders_with_real_data() abort

  let text = '%project_root%/some-file.txt'
  let values = { 'project_root': '/tmp' }
  let result = vcoder#util#resolve_placeholders(text, values)
  call s:assert.equal(result, '/tmp/some-file.txt')
endfunction


function! s:suite.test_resolve_placeholders_with_wrap_char_argument_replaces_placeholders_with_real_data() abort

  let text = '#project_root#/some-file.txt'
  let values = { 'project_root': '/tmp' }
  let result = vcoder#util#resolve_placeholders(text, values, '#')
  call s:assert.equal(result, '/tmp/some-file.txt')
endfunction

function! s:suite.test_resolve_placeholders_returns_original_text_if_no_placeholder_match() abort

  let text = '%project_root%/some-file.txt'
  let values = { 'some_key': '/tmp' }
  let result = vcoder#util#resolve_placeholders(text, values, '#')
  call s:assert.equal(result, '%project_root%/some-file.txt')
endfunction
