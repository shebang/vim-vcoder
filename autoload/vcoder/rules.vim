function! vcoder#rules#_get() abort
  if !exists('s:rules')
    call vcoder#rules#_init()
  endif

  return s:rules
endfunction

function! vcoder#rules#_init() abort
  let s:rules = {}

  " this is the active configuration, not to be confused with defaults (TODO)
  let s:rules.ft = {}
  let s:rules.ft.vim = {}
  let s:rules.ft.vim.testrunner = 'themis'
  let s:rules.ft.vim.testfile = {
    \ 'location': '%project_root%/test/themis/%source_dir%/%source_fname%',
    \ 'autoexec': v:true,
    \ }

endfunction


function! vcoder#rules#for(ft, rule, expr) abort
  let rules = vcoder#rules#_get()
  "TODO: impl.
  "
  "
endfunction