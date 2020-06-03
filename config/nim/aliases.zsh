#!/usr/bin/env zsh

nimx() {
    bin=$1
    src="$bin.nim"
    shift

    if [[ ! -f "$bin" || "$src" -nt "$bin" ]]; then
        echo "Compiling $src..."
        nim c --verbosity:0 --hint[Processing]:off --excessiveStackTrace:on $src
    fi

    $bin $@
}
