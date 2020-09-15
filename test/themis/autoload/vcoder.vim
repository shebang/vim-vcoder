let s:suite = themis#suite('vcoder')
let s:scope = themis#helper('scope')
let s:assert = themis#helper('assert')


function! s:suite.before_each() abort

endfunction


function! s:suite.test_vcoder() abort


  call vcoder#rules#for('vim', 'testfile', {
    \ 'location': '%project_root%/test/themis/%file_project_dir%/%file_name%',
    \ 'autoexec': v:true,
    \ })


  call vcoder#enable('vim')

endfunction
