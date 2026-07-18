#!/bin/bash

###########################################################
# Module Registry
###########################################################

MODULE_DIR="/opt/labctl/modules"

list_modules() {

    find "$MODULE_DIR" \
        -mindepth 1 \
        -maxdepth 1 \
        -type d \
        -printf "%f\n" \
        | sort

}

module_exists() {

    [[ -d "$MODULE_DIR/$1" ]]

}

load_module() {

    local NAME="$1"

    module_exists "$NAME" || return

    for FILE in "$MODULE_DIR/$NAME"/*.sh
    do
        [[ -f "$FILE" ]] && source "$FILE"
    done

}