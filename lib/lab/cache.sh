#!/bin/bash

###############################################################################
# LAB CACHE ENGINE
###############################################################################

lab_cache_file() {

    printf '%s/lab-%s\n' "$CACHE_DIR" "$1"

}

lab_cache_exists() {

    [[ -f "$(lab_cache_file "$1")" ]]

}

lab_cache_age() {

    local FILE

    FILE=$(lab_cache_file "$1")

    [[ -f "$FILE" ]] || return 1

    echo $(( $(date +%s) - $(stat -c %Y "$FILE") ))

}

lab_cache_read() {

    cat "$(lab_cache_file "$1")"

}

lab_cache_write() {

    local NAME="$1"

    shift

    mkdir -p "$CACHE_DIR" || return 1
    printf "%s\n" "$@" > "$(lab_cache_file "$NAME")"

}

lab_cache_clear() {

    rm -f "$CACHE_DIR"/lab-*

}
