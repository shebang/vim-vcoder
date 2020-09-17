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
  let s:spec.targets = {}
  let s:spec.targets.file = {}
  let s:spec.targets.file.cmd = { context -> s:test_file(context) }
  let s:spec.targets.file.args = []
  let s:spec.targets.project = {}
  let s:spec.targets.project.cmd = { context -> s:test_project(context) }
  let s:spec.targets.project.args = ['-r']
  let s:spec.is_installed = { -> filereadable(s:spec.cmd) }
  let s:spec.test_project = { context -> s:test_project(context) }
  let s:spec.test_file = { context -> s:test_file(context) }

  return s:spec
endfunction

function! s:test_project(context) abort
  return [s:spec.cmd] + s:spec.targets.project.args + [a:context.targets.project]
endfunction


function! s:test_file(context) abort
  return [s:spec.cmd] + s:spec.targets.project.args + [a:context.targets.file]
endfunction

"" {{{1: Implementation
"" ============================================================================


