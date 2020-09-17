# Feature: Refactoring Test Targets

Goal: Run tests for a file, project or a piece of code.
What we have so far:

* context 'object' which gets updated when a file is loaded
* context maintains possible test targets which could be a file, directory or
  lines of code (or a symbol?)

What we need:

* A general approach for running something which is called a test runner.
* Test runner expect a context for initialization.
* A test runner should only run those tests which I'm interested of. This should
  be configurable.

# Writing a Test Runner

This little guide explains how to extend vcoder with your own test runner. We
are using [vim-themis](https://github.com/thinca/vim-themis) for this guide
which is a 'is a testing framework for Vim script.'


## Initialization 

Each test runner must be registered by calling ```vcoder#testrunner#register```






