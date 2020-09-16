" {{{1: Interface
" ============================================================================

function! vcoder#testrunner#themis#init() abort

  let s:themis = {}
  let s:themis.path_repo = vcoder#cache_path() . '/vim-themis'
  let s:themis.cmd = vcoder#cache_path() . '/vim-themis/bin/themis'
  let s:themis.build_cmd = ['git', 'clone',
    \ 'https://github.com/thinca/vim-themis ',
    \ vcoder#cache_path() . '/vim-themis']

  let s:themis.is_deployed = { -> vcoder#testrunner#themis#is_deployed() }
  let s:themis.args = []

  if ! isdirectory(s:themis.path_repo)
    call mkdir(s:themis.path_repo, 'p')
  endif

  return s:themis
endfunction

function! vcoder#testrunner#themis#is_deployed() abort
   return filereadable(s:themis.cmd)
endfunction

function! vcoder#testrunner#themis#runner(context) abort

  if a:context.testmode ==? 'single'
    let cmd = [s:themis.cmd] + s:themis.args + [a:context.test_candidate]
    call vcoder#testrunner#jobstart([join(cmd)])
  endif
endfunction

"" {{{1: Implementation
"" ============================================================================


