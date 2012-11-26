"Author: Zachary Stigall
"Version: 0.1
"Last Change: 26 Nov 2012
"License: VIM License

"About: Vim Smart Swap is a plugin that ties into vims swap file detection and
"  automatically deletes the swap if it is older or identical to the opened
"  file.
"
"Disclaimer: Not responsible for loss of data, use at own risk

function! smartswap#main()
    let s:old_swapchoice = v:swapchoice
    augroup SmartSwap
        au!
        au SwapExists * nested :call <sid>checkSwap()
    augroup END
endfunction

function! s:checkSwap()
endfunction
