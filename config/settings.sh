#!/usr/bin/env bash

###############################################################################
# Configuration Manager
###############################################################################

declare -Ag SETTINGS=()


DEFAULT_FILE="${LABCTL_HOME}/config/default.conf"

settings_load_defaults() {

    while IFS='=' read -r KEY VALUE
    do
        [[ "$KEY" =~ ^readonly ]] || continue

        KEY="${KEY#readonly }"
        KEY="${KEY%% *}"

        VALUE="${VALUE#\"}"
        VALUE="${VALUE%\"}"

        SETTINGS["$KEY"]="$VALUE"

    done < "$DEFAULT_FILE"

}

settings_load_user() {

    [[ -f "$CONFIG_FILE" ]] || return 0

    while IFS='=' read -r KEY VALUE
    do

        [[ "$KEY" =~ ^# ]] && continue
        [[ -z "$KEY" ]] && continue

        SETTINGS["$KEY"]="$VALUE"

    done < "$CONFIG_FILE"

}

settings_init() {

    mkdir -p "$CONFIG_DIR"

    settings_load_defaults

    settings_load_user

}

settings_get() {

    local KEY="$1"

    printf "%s\n" "${SETTINGS[$KEY]}"

}

settings_set() {

    local KEY="$1"
    local VALUE="$2"

    SETTINGS["$KEY"]="$VALUE"

}

settings_has() {

    local KEY="$1"

    [[ -v SETTINGS["$KEY"] ]]

}

settings_unset() {

    local KEY="$1"

    unset SETTINGS["$KEY"]

}

settings_save() {

    mkdir -p "$CONFIG_DIR"

    : > "$CONFIG_FILE"

    local KEY

    for KEY in "${!SETTINGS[@]}"
    do

        printf "%s=%s\n" \
            "$KEY" \
            "${SETTINGS[$KEY]}" \
            >> "$CONFIG_FILE"

    done

}

settings_reset() {

    local KEY="$1"

    settings_load_defaults

    settings_save

}

settings_reset_all() {

    rm -f "$CONFIG_FILE"

    SETTINGS=()

    settings_load_defaults

    settings_save

}

settings_list() {

    local KEY

    for KEY in "${!SETTINGS[@]}"
    do

        printf "%-25s %s\n" \
            "$KEY" \
            "${SETTINGS[$KEY]}"

    done

}

settings_export() {

    local FILE="$1"

    cp "$CONFIG_FILE" "$FILE"

}

settings_import() {

    local FILE="$1"

    cp "$FILE" "$CONFIG_FILE"

    SETTINGS=()

    settings_init

}

settings_reload() {

    SETTINGS=()

    settings_init

}

settings_validate() {

    local REQUIRED=(
        LOG_LEVEL
        PING_TIMEOUT
        DNS_TARGET
        INTERNET_TARGET
        DEFAULT_PROFILE
    )

    local KEY

    for KEY in "${REQUIRED[@]}"
    do

        if ! settings_has "$KEY"
        then

            log_error "$KEY missing."

            return 1

        fi

    done

}