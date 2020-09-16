let s:suite = themis#suite('vcoder_testrunner')
let s:scope = themis#helper('scope')
let s:assert = themis#helper('assert')


function! s:suite.before_each() abort

endfunction

function! s:suite.test_testrunner_jobstart() abort

  call vcoder#testrunner#jobstart(['ls'])
endfunction

" function! s:suite.test_testrunner() abort

"   function! s:handler(job_id, data, event_type)
"     verbose echom a:job_id . ' ' . a:event_type
"     verbose echom join(a:data, "\n")
"   endfunction

"   if has('win32') || has('win64')
"     let argv = ['cmd', '/c', 'dir c:\ /b']
"   else
"     let argv = ['bash', '-c', 'ls']
"   endif

"   let jobid = vcoder#job#start(argv, {
"     \ 'on_stdout': function('s:handler'),
"     \ 'on_stderr': function('s:handler'),
"     \ 'on_exit': function('s:handler'),
"     \ })

"   if jobid > 0
"     verbose echom 'job started'
"   else
"     verbose echom 'job failed to start'
"   endif

"   call s:assert.equal(1,1)
" endfunction
