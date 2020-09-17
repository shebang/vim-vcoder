let s:suite = themis#suite('vcoder')
let s:scope = themis#helper('scope')
let s:assert = themis#helper('assert')


function! s:suite.before_each() abort
  call vcoder#init()
endfunction

function! s:suite.test_cache_path_is_valid() abort
  let result = vcoder#cache_path()
  call s:assert.match(result, '\.cache/vcoder')
endfunction

function! s:suite.test_enabled_ft_is_empty_by_default() abort
  let result = vcoder#enabled_ft()
  call s:assert.equal(result, [])
endfunction

function! s:suite.test_enabled_with_arg_vim_enables_ft_vim() abort
  call vcoder#enable(['vim'])
  let result = vcoder#enabled_ft()
  call s:assert.equal(result, ['vim'])
endfunction

function! s:suite.test_is_enabled_returns_true_if_ft_is_enabled() abort
  call vcoder#enable(['vim'])
  let result = vcoder#is_enabled('vim')
  call s:assert.equal(result, v:true)
endfunction

function! s:suite.test_disable_with_arg_vim_disables_ft_vim() abort
  call vcoder#enable(['vim'])
  let result = vcoder#enabled_ft()
  call s:assert.equal(result, ['vim'])

  call vcoder#disable('vim')
  let result = vcoder#enabled_ft()
  call s:assert.equal(result, [])
endfunction


