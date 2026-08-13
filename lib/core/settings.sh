#!/usr/bin/env bash

###############################################################################
# Settings
###############################################################################

settings_create() {

    mkdir -p "$CONFIG_DIR"

    cp "$CONFIG_TEMPLATE" "$CONFIG_FILE"

}

settings_load() {

    [[ -f "$CONFIG_FILE" ]] || settings_create

    source "$CONFIG_FILE"

}

settings_get() {

    local KEY="$1"

    grep "^${KEY}=" "$CONFIG_FILE" \
        | head -n1 \
        | cut -d= -f2-

}

settings_set() {

    local KEY="$1"

    local VALUE="$2"

    sed -i \
        "s|^${KEY}=.*|${KEY}=${VALUE}|" \
        "$CONFIG_FILE"

}


settings_exists() {

    [[ -f "$CONFIG_FILE" ]]

}

settings_reset() {

    rm -f "$CONFIG_FILE"

    settings_create

}

settings_list() {

    grep "=" "$CONFIG_FILE"

}