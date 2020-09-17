# vim-vcoder

vcoder is a test execution framework for vim. The project has just been started
so there's no real functionality right now besides running a single test for a vim script
via [themis](https://github.com/thinca/vim-themis).

Goals:

* asynchronous tests (requires Vim 8/ Neovim)
* keep it small and easy to use

## Usage Proposal

### Define Test Directory Layout

In order to run tests on single files or to execute a test suite vcoder needs
to know the test directory structure. You can use the following placeholders:

* `%project_root%`: resolves to project root
* `%file_project_dir%`: the relative path to the source file starting from project root
* `%file_name%`: the file name 

```vim
" Define testfile location
call vcoder#rules#for('vim', 'testfile', {
  \ 'location': '%project_root%/test/themis/%source_dir%/%source_fname%',
  \ 'autoexec': v:true,
  \ })
```

### Define Test Runner

```vim
" Define testrunner
call vcoder#rules#for('vim', 'testrunner', 'themis')
```
### Enable vcoder 

```vim
" Enable vcoder for vim
call vcoder#enable(['vim'])
```
## Credits

This project is a fun and learning project. Many thanks to [Shougo](https://github.com/Shougo)
which I learned a lot from and who is famous for his numerous vim plugins.  


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


