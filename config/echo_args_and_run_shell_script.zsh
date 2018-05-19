#!/bin/zsh
echo $* | sed 's/NEWLINE/\n/g'
$SHELL
