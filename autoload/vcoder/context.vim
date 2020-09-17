
let s:context = {}
let s:context.buffers = {}

if !exists('#vcoder_context_handler')
  augroup vcoder_context_handler
    autocmd!
    autocmd BufRead * call vcoder#context#update()
    autocmd FileType * call vcoder#context#set_filetype()
  augroup END
endif

function! vcoder#context#get() abort
  return s:context
endfunction

" FIXME: must be configurable and reliable
" REFACTOR: all path related functions must be put in a separate module
function! vcoder#context#project_root(ft) abort
  let git_root = finddir('.git', '.;')
  if empty(git_root)
    return
  endif

  return fnamemodify(git_root, ':p:h:h')
endfunction

function! vcoder#context#testrunner(context) abort
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

  let runner_func = 'vcoder#testrunner#' . rules.testrunner . '#runner'

  return runner_func
endfunction

function! vcoder#context#get_test_candidate(context) abort
  if !has_key(a:context, 'ft')
    return
  endif

  if empty(a:context.ft)
    return
  endif

  let rules = vcoder#rules#_get()['ft'][a:context.ft].testfile

  if has_key(rules, 'location')
    let test_candidate = vcoder#util#resolve_placeholders(rules.location, a:context)
    let a:context.test_candidate = filereadable(test_candidate) ? test_candidate : ''
  endif

  return a:context
endfunction

function! vcoder#context#set_filetype() abort

  let ft = expand('<amatch>')

  " filetype is not enabled for vcoder
  if index(vcoder#enabled_ft(), ft) < 0
    return
  endif

  " filetype is not configured, so ignore
  if !has_key(vcoder#rules#_get()['ft'], ft)
    return
  endif

  " why the heck does this not work?
  " let file_candidate = expand('<afile')

  let testfile_rules = vcoder#rules#_get()['ft'][ft].testfile
  if has_key(testfile_rules, 'exclude_pattern')
    if expand("<afile>") =~? testfile_rules.exclude_pattern
      return
    endif
  endif

  let s:context.buffers[fnamemodify(expand("<afile>"), ':p')] = {'ft': ft}
  call vcoder#context#update()

endfunction


function! vcoder#context#update() abort
  let file_name = expand('%:p')

  if !has_key(s:context.buffers, file_name)
    return
  endif

  let file_context = s:context.buffers[file_name]
  let file_context.current_file = file_name
  let file_context.file_name = expand('%:t')
  let file_context.project_root = vcoder#context#project_root('vim')
  let file_context.file_project_dir = fnamemodify(strpart(file_context.current_file, strlen(file_context.project_root)+1), ':h')

  let file_context.testrunner = vcoder#context#testrunner(file_context)
  let file_context.testmode = 'single'
  let file_context = vcoder#context#get_test_candidate(file_context)

endfunction
