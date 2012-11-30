SmartSwap
=========

Handles vim swap files in an intelligent way

This plugin will delete a detected swapfile if the swapfile is older than the
file being opened or if the swapfile is identical to the file being opened.

Configuration:
--------------
Two global variables control the behavior of this plugin.

g:SmartSwap_CheckDate -> When set to 0, will disable checking of the date stamps

g:SmartSwap_CheckDiff -> When set to 0, will disable doing a diff of the swap
and file being opened

Disclaimer:
-----------
Not responsible for loss of data. Use at own risk :)
