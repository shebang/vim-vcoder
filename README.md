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

## Design Notes

### Structure  
* Rules: Define what to do for certain filetypes. Because is is hard to guess
  how people organize their test files do not make detailed assumptions. Single
  responsibility for rules is defining possible targets and actions (config data). 
* Event: Gather data on events and dispatch events for enabled filetypes.
* Context: The current context for a possible test run. Context is the glue
  between rules, events and test runners.
* Test Runner: Executes tests by applying a test execution strategy.
* Result View: Display test result when data is available. Uses an interface to
  provide a concrete view mechanism (previewwindow, fzf, whatever)

### Asynchronous Event Handling

This project uses Async.Promise from vital.vim for handling asynchronous
callbacks. Async.Promis mimics [Javascript's Promise API](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise)
and should be fun to use for any Node developer ;)

[![Powered by vital.vim](https://img.shields.io/badge/powered%20by-vital.vim-80273f.svg)](https://github.com/vim-jp/vital.vim)

