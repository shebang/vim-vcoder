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

  let s:spec = {}
  let s:spec.name = 'themis'
  let s:spec.dir_name = vcoder#cache_path() . '/vim-themis'
  let s:spec.install_cmd = [
    \ 'git', 'clone', 'https://github.com/thinca/vim-themis ', s:spec.dir_name]
  let s:spec.update_cmd = [ 'cd', s:spec.dir_name,  'git', 'pull', 'cd -']

  let s:spec.cmd = s:spec.dir_name . '/bin/themis'
  let s:spec.args = []
  let s:spec.test_file = { context -> vcoder#testrunner#themis#test_file(context) }

  return s:spec
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

function! vcoder#testrunner#themis#test_file(context) abort
  return [s:spec.cmd] + s:spec.args + [a:context.test_candidate]
endfunction

function! vcoder#testrunner#themis#runner(context) abort

  if a:context.testmode ==? 'single'
    let cmd = [s:themis.cmd] + s:themis.args + [a:context.test_candidate]
    call vcoder#testrunner#jobstart([join(cmd)])
  endif
endfunction

"" {{{1: Implementation
"" ============================================================================


