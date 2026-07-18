#!/bin/bash

###############################################################################
# LAB CACHE ENGINE
###############################################################################

CACHE_DIR="/var/cache/labctl"

mkdir -p "$CACHE_DIR"

cache_file() {

    echo "$CACHE_DIR/$1"

}

cache_exists() {

    [[ -f "$(cache_file "$1")" ]]

}

cache_age() {

    local FILE

    FILE=$(cache_file "$1")

    [[ -f "$FILE" ]] || return 1

    echo $(( $(date +%s) - $(stat -c %Y "$FILE") ))

}

cache_read() {

    cat "$(cache_file "$1")"

}

cache_write() {

    local NAME="$1"

    shift

    printf "%s\n" "$@" > "$(cache_file "$NAME")"

}

cache_clear() {

    rm -f "$CACHE_DIR"/*

}