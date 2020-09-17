" {{{1: Interface
" ============================================================================
""
" Returns a spec |Dict| for registering this test runner with vcoder.
"
" * testrunner_spec.name: the name of this test runner
" * testrunner_spec.install_cmd: the command to use for installing your test runner
" * testrunner_spec.update_cmd: the command to use for updating your test runner
" * testrunner_spec.cmd: The command to execute test runner
" * testrunner_spec.args Additional argruments for the cmd
"
"
function! vcoder#testrunner#themis#spec() abort

  let spec = {}
  let spec.name = 'themis'
  let spec.dir_name = vcoder#cache_path() . '/vim-themis'
  let spec.install_cmd = [
    \ 'git', 'clone', 'https://github.com/thinca/vim-themis ', spec.dir_name]
  let spec.update_cmd = [ 'cd', spec.dir_name,  'git', 'pull', 'cd -']

  let spec.cmd = spec.dir_name . '/bin/themis'
  let spec.args = []

  return spec
endfunction


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


