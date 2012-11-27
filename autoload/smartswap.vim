"Author: Zachary Stigall
"Version: 0.1
"Last Change: 27 Nov 2012
"License: VIM License

"About: Vim Smart Swap is a plugin that ties into vim's swap file detection and
"  automatically deletes the swap if it is older or identical to the opened
"  file. There are many places where code has been taken and modified from the
"  Recover.vim plugin, since it does something similar.
"
"Disclaimer: Not responsible for loss of data, use at own risk :)

function! smartswap#main()
    let s:old_swapchoice = v:swapchoice
    augroup SmartSwap
        au!
        "This does a smart removal of the swap file if it exists and is the
        "same or older than the file
        au SwapExists * nested :call <sid>smartRemoveSwap()
        "This fixes when the above removes and shouldn't, and is effectively
        "the same as Recover.vim
        au BufWinEnter,InsertEnter,InsertLeave,FocusGained * call <sid>checkSwap()
    augroup END
endfunction

function! s:smartRemoveSwap()
    if !&swapfile
        return
    endif

    let s:sname = shellescape(s:swapName())
    let s:fname = shellescape(expand('%:p'))

    "Get the modification times for both the swap file and opened file
    let swapModTime = getftime(s:sname)
    let fileModTime = getftime(s:fname)
    if swapModTime >= fileModTime
        "let vim handle deleting of the swap file
        let v:swapchoice = 'd'
        echo 'Swap is older than buffer, deleting swap'
    endif

"    "Check diff of buffer and swap, this is also taken from Recover.vim
"    let tempf = tempname()
"    let cmd = printf("vim -u NONE -U NONE -N -es -r %s -c ':w %s|:q!' && diff %s %s",
"                \ shellescape(v:swapname), tempf, s:fname, tempf)
"    call system(cmd)
"    let retCode = !v:shell_error
"    call delete(tempf)
"
"    if retCode
"        let v:swapchoice = 'd'
"        echo 'Swap and buffer are the same, deleteing old swap'
"    endif
endfunction

function! s:checkSwap()
    "Taken from Recover.vim plugin, s:CheckSwapFileExists
    "https://github.com/chrisbra/Recover.vim
    if !&swapfile
        return
    endif

    let name = s:swapName()
    if !empty(name) && !filereadable(name)
        " previous SwapExists autocommand deleted our swapfile,
        " recreate it and avoid E325 Message
        call s:resetSwap()
    endif
endfunction

function! s:swapName()
    "Taken from Recover.vim plugin, s:Swapname
    "https://github.com/chrisbra/Recover.vim
    silent! redir => a |silent swapname|redir end
    if a[1:] == 'No swap file'
        return ''
    else
        return a[1:]
    endif
endfunction

function! s:resetSwap()
    "Taken from Recover.vim plugin, s:SetSwapFile()
    "https://github.com/chrisbra/Recover.vim
    if &l:swf
        " Reset swapfile to use .swp extension
        sil setl noswapfile swapfile
    endif
endfunction

" vim: et sw=4 ts=4
