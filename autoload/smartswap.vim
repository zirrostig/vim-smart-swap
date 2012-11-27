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
        au SwapExists * nested :call smartswap#SmartRemoveSwap()
        "This fixes when the above removes and shouldn't, and is effectively
        "the same as Recover.vim
        au BufWinEnter,InsertEnter,InsertLeave,FocusGained * call smartswap#CheckSwap()
    augroup END
endfunction

function! smartswap#SmartRemoveSwap()
    if !&swapfile
        return
    endif

    "User var if the user doesn't want to check the time stamps
    if !exists("g:SmartSwap_CheckDate") || g:SmartSwap_CheckDate > 0
        call smartswap#CheckTimeStamps()
    endif
    "if CheckTimeStamps set v:swapchoice, we're done
    "User var if the user doesn't want to check the diff state
    if !exists("g:SmartSwap_CheckDiff") || g:SmartSwap_CheckDiff > 0
        if !exists("g:swapchoice")
            call smartswap#CheckDiff()
        endif
    endif
endfunction

function! smartswap#CheckTimeStamps()
    "Get the modification times for both the swap file and opened file
    let swapModTime = getftime(v:swapname)
    let fileModTime = getftime(expand('%:p'))
    if swapModTime <= fileModTime
        "let vim handle deleting of the swap file
        let v:swapchoice = 'd'
        echo 'Swap is older than buffer, deleting swap'
        return
    else
        echo 'Swap is newer than buffer...'
    endif
endfunction

function! smartswap#CheckDiff()
    "Check diff of buffer and swap, this is also taken from Recover.vim
    let tempf = tempname()

    "Create a temp file with the contents of the swapfile
    let cmd = printf("vim -u NONE -U NONE -N -es -r %s -c ':wq! %s'", shellescape(v:swapname), tempf)
    call system(cmd)

    "Diff the temp with file
    let cmd = printf("diff %s %s", shellescape(expand('%:p')), tempf)
    call system(cmd)

    "Get Return Code and delete the temp file
    let delSwap = !v:shell_error
    call delete(tempf)

    "If diff returned 0, then delete the swap file
    if delSwap
        let v:swapchoice = 'd'
        echo 'Swap and buffer are the same, deleteing old swap'
        return
    else
        echo 'Swap and buffer differ...'
    endif
endfunction


function! smartswap#CheckSwap()
    "Taken from Recover.vim plugin, s:CheckSwapFileExists
    "https://github.com/chrisbra/Recover.vim
    if !&swapfile
        return
    endif

    let name = smartswap#SwapName()
    if !empty(name) && !filereadable(name)
        " previous SwapExists autocommand deleted our swapfile,
        " recreate it and avoid E325 Message
        call smartswap#ResetSwap()
    endif
endfunction

function! smartswap#SwapName()
    "Taken from Recover.vim plugin, s:Swapname
    "https://github.com/chrisbra/Recover.vim
    silent! redir => a |silent swapname|redir end
    if a[1:] == 'No swap file'
        return ''
    else
        return a[1:]
    endif
endfunction

function! smartswap#ResetSwap()
    "Taken from Recover.vim plugin, s:SetSwapFile()
    "https://github.com/chrisbra/Recover.vim
    if &l:swf
        " Reset swapfile to use .swp extension
        sil setl noswapfile swapfile
    endif
endfunction

" vim: et sw=4 ts=4
