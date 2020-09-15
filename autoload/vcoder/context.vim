function! vcoder#context#get() abort
  if !exists('s:context')
    let s:context = {}
  endif
  return s:context
endfunction

"FIXME: must be configurable and reliable
function! vcoder#context#project_root(ft) abort
  let git_root = finddir('.git', '.;')
  if empty(git_root)
    return
  endif

  return fnamemodify(git_root, ':p:h:h')
endfunction

function! vcoder#context#get_testrunner(context) abort
  if empty(a:context)
    return
  endif

  if !has_key(a:context, 'ft')
    return
  endif

  let rules = vcoder#rules#_get()['ft'][a:context.ft]
  if !has_key(rules, 'testrunner')
    return
  endif

  let init_func = 'vcoder#testrunner#' . rules.testrunner . '#init'
  let testrunner = call(init_func, [a:context])

  return testrunner
endfunction

function! s:eval_testfile_location(context, location) abort
  let test_candidate = a:location

  if test_candidate =~? '%project_root%'
    let test_candidate = substitute(test_candidate, '%project_root%', a:context.project_root, 'g')
  endif


  if test_candidate =~? '%source_dir%'
    let test_candidate = substitute(test_candidate, '%source_dir%', a:context.file_relative_path, 'g')
  endif


  if test_candidate =~? '%source_fname%'
    let test_candidate = substitute(test_candidate, '%source_fname%', a:context.file_name, 'g')
  endif

  return filereadable(test_candidate) ? test_candidate : ''
endfunction

function! vcoder#context#get_test_candidate(context) abort
  if !has_key(a:context, 'ft')
    return
  endif

  if empty(a:context.ft)
    return
  endif

  let rules = vcoder#rules#_get()['ft'][a:context.ft].testfile

  if !has_key(rules, 'location')
    return
  endif

  return s:eval_testfile_location(a:context, rules['location'])

endfunction

function! vcoder#context#update() abort
  let context = {}
  let context.ft = &l:ft
  let context.current_file = expand('%:p')
  let context.file_name = expand('%:t')
  let context.project_root = vcoder#context#project_root('vim')
  let context.file_relative_path = fnamemodify(strpart(context.current_file, strlen(context.project_root)+1), ':h')

  let s:context = {}
  let s:context = extend(s:context, context)
  let s:context.test_candidate = vcoder#context#get_test_candidate(context)

endfunction
