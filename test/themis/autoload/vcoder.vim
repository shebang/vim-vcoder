let s:suite = themis#suite('vcoder')
let s:scope = themis#helper('scope')
let s:assert = themis#helper('assert')


function! s:suite.before_each() abort

endfunction


function! s:suite.test_vcoder() abort


  call vcoder#rules#for('vim', 'testfile', {
    \ 'location': '%project_root%/test/themis/%source_dir%/%source_fname%',
    \ 'autoexec': v:true,
    \ })


  call vcoder#enable('vim')

endfunction
