# vim-vcoder

vcoder is a test execution framework for vim. The project has just been started
so there's no real functionality right now besides running a single test for a vim script
via [themis](https://github.com/thinca/vim-themis).

I use vital.vim for managing external dependencies.

Goals:

* asynchronous tests (Async.Promise from vital.vim, requires Vim8/ Neovim)
* declarative configuration
* keep it small and easy to use

## Usage Proposal

```vim
" Define testfile location
call vcoder#rules#for('vim', 'testfile', {
  \ 'location': '%project_root%/test/themis/%source_dir%/%source_fname%',
  \ 'autoexec': v:true,
  \ })

" Define testrunner
call vcoder#rules#for('vim', 'testrunner', 'themis')

" Enable vcoder for vim
call vcoder#enable('vim')
```


[![Powered by vital.vim](https://img.shields.io/badge/powered%20by-vital.vim-80273f.svg)](https://github.com/vim-jp/vital.vim)

