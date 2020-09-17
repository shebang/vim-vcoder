""
" @section Introduction, intro
" @stylized shebang
" @library
" @order intro dict
" vcoder is a test execution framework for vim.
"

function! vcoder#init() abort
  let s:vcoder = {}
  let s:vcoder.cache_path =
    \ expand(($XDG_CACHE_HOME ? $XDG_CACHE_HOME : '~/.cache') . '/vcoder', 1)

  call vcoder#rules#_init()
  call vcoder#testrunner#init()
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
  return s:vcoder.cache_path
endfunction

function! vcoder#is_enabled(ft) abort
  return vcoder#event#_is_enabled(a:ft)
endfunction
