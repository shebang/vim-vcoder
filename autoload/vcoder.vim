if !exists('s:vcoder')
  let s:vcoder = {}
  let s:vcoder.cache_path =
  \ expand(($XDG_CACHE_HOME ? $XDG_CACHE_HOME : '~/.cache') . '/vcoder', 1)
  let s:vcoder.enabled = []
endif

function! vcoder#enable(ft_list) abort

  if type(a:ft_list) != v:t_list
    throw 'ERROR(InvalidArguments): 1st argument of vcoder#enable must be a list of filetypes.'
  endif

  " FIXME: validation
  let s:vcoder.enabled += a:ft_list
  call vcoder#rules#_init()
  call vcoder#event#init()
  call vcoder#testrunner#init()
endfunction

function! vcoder#enabled_ft() abort
  return s:vcoder.enabled
endfunction

function! vcoder#cache_path() abort
  return s:vcoder.cache_path
endfunction

function! vcoder#is_enabled(ft) abort
  return index(s:vcoder.enabled, a:ft) >= 0 ? 1 : 0
endfunction
