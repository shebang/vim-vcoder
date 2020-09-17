""
" @section Introduction, intro
" @stylized shebang
" @library
" @order intro installation
" vcoder is a test execution framework for vim. It's main purpose is for
" programmers who want to run automated tests in their editor.
"

""
" @section Installation, installation
"
" vcoder uses a declarative style to configure the behaviour of text execution.
"
" >
"   call vcoder#testrunner#register('themis')
"
"   call vcoder#rules#for('vim', 'testfile', {
"     \ 'location': '%project_root%/test/themis/%file_project_dir%/%file_name%',
"     \ })
"   call vcoder#rules#for('vim', 'testproject', {
"     \ 'location': '%project_root%/test/themis',
"     \ })
"   call vcoder#rules#for('vim', 'testrunner', 'themis')
"
"   call vcoder#enable(['vim'])
" <
"
"




function! vcoder#init() abort
  let s:vcoder = {}
  let s:vcoder.cache_path =
    \ expand(($XDG_CACHE_HOME ? $XDG_CACHE_HOME : '~/.cache') . '/vcoder', 1)

  call vcoder#rules#_init()
  " call vcoder#testrunner#init()
endfunction


function! vcoder#enable(ft_or_list) abort
  return vcoder#event#_enable(a:ft_or_list)
endfunction

function! vcoder#disable(ft_or_list) abort
  return vcoder#event#_disable(a:ft_or_list)
endfunction

function! vcoder#enabled_ft() abort
  return vcoder#event#_enabled_ft()
endfunction

function! vcoder#cache_path() abort
  if !exists('s:vcoder')
    call vcoder#init()
  endif
  return s:vcoder.cache_path
endfunction

function! vcoder#is_enabled(ft) abort
  return vcoder#event#_is_enabled(a:ft)
endfunction
