#!/usr/bin/env bash

###############################################################################
# Settings
###############################################################################

settings_create() {

    mkdir -p "$CONFIG_DIR"

    [[ -f "$CONFIG_FILE" ]] && return "$EXIT_SUCCESS"

    cp "$CONFIG_TEMPLATE" "$CONFIG_FILE"

}

settings_load() {

    if [[ -f "$CONFIG_FILE" ]]; then
        source "$CONFIG_FILE"
    else
        # Commands such as `help` and `version` must not create user state.
        # Installation is responsible for writing the initial configuration.
        source "$CONFIG_TEMPLATE"
    fi

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

    settings_create || return $?

    if grep -q "^${KEY}=" "$CONFIG_FILE"; then
        sed -i "s|^${KEY}=.*|${KEY}=${VALUE}|" "$CONFIG_FILE"
    else
        printf '%s=%s\n' "$KEY" "$VALUE" >> "$CONFIG_FILE"
    fi

}


settings_exists() {

    [[ -f "$CONFIG_FILE" ]]

}

settings_reset() {

    rm -f "$CONFIG_FILE"

    settings_create

}

settings_unset() {

    local KEY="$1"

    [[ -f "$CONFIG_FILE" ]] || return "$EXIT_SUCCESS"

    sed -i "/^${KEY}=/d" "$CONFIG_FILE"

}

settings_list() {

    grep "=" "$CONFIG_FILE"

}
