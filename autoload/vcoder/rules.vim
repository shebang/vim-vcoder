function! vcoder#rules#_get() abort
  if !exists('s:rules')
    call vcoder#rules#_init()
  endif

  return s:rules
endfunction

function! vcoder#rules#_init() abort
  let s:rules = {}
  let s:rules.testrunners = ['themis']
  " this is the active configuration, not to be confused with defaults (TODO)
  let s:rules.ft = {}
  let s:rules.ft.vim = {}
  let s:rules.ft.vim.testrunner = 'themis'
  let s:rules.ft.vim.testfile = {
    \ 'location': '%project_root%/test/themis/%file_project_dir%/%file_name%',
    \ 'exclude_pattern': 'test\/themis',
    \ 'autoexec': v:true,
    \ }
  let s:rules.ft.vim.testsuite = {
    \ 'location': '%project_root%/test/themis',
    \ 'autoexec': v:true,
    \ }


endfunction

function! vcoder#rules#testrunners() abort
  return s:rules.testrunners
endfunction

function! vcoder#rules#for(ft, rule, expr) abort
  let rules = vcoder#rules#_get()
  "TODO: impl.
  "
  "
endfunction
