"Author: Zachary Stigall
"Version: 0.1
"Last Change: 27 Nov 2012
"License: VIM License
"
"About: Vim Smart Swap is a plugin that ties into vim's swap file detection and
"  automatically deletes the swap if it is older or identical to the opened
"  file. There are many places where code has been taken and modified from the
"  Recover.vim plugin, since it does something similar.
"
"Disclaimer: Not responsible for loss of data, use at own risk :)

if exists("g:loaded_recover") || &cp
    finish
endif

let g:loaded_recover = 1
let keepcpo = &cpo "backup user settings
set cpo&vim "defaults

call smartswap#main()

let &cpo = keepcpo
unlet keepcpo



" vim: et sw=4 ts=4
