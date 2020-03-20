#!/usr/bin/env zsh

ediff() { e --eval "(ediff-files \"$1\" \"$2\")"; }

alias e="emacsclient -a '' -c -F '(make-frame)'"
