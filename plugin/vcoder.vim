"=============================================================================
" FILE: vcoder.vim
" AUTHOR:  A. Lueckerath <al@shebang.org>
" License: MIT license
"=============================================================================

if exists('g:loaded_vcoder')
  finish
endif
let g:loaded_vcoder = 1

command! VcoderTestFile call vcoder#event#dispatch()
