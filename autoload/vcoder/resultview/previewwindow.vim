
if !exists('s:previewheight_orig')
  let s:previewheight_orig = &previewheight
endif


let s:previewwindow_name = '\[VCODER RESULT\]'
let s:previewwindow_ft = 'tap'

" from: https://vi.stackexchange.com/questions/19056/how-to-create-preview-window-to-display-a-string
function! vcoder#resultview#previewwindow#display_lines(lines)
  let &previewheight = 6
  let l:command = "silent! pedit! +setlocal\\ " .
    \ "buftype=nofile\\ nobuflisted\\ " .
    \ "noswapfile\\ nonumber\\ " .
    \ "filetype=" . s:previewwindow_ft . " " . s:previewwindow_name

  exe l:command
  let &previewheight = s:previewheight_orig

  if has('nvim')
    let l:bufNr = bufnr(s:previewwindow_name)
    call nvim_buf_set_lines(l:bufNr, 0, -1, 0, a:lines)
  else
    call bufload(s:previewwindow_name)
    call setbufline(s:previewwindow_name, 1, a:lines)
  endif
endfunction
