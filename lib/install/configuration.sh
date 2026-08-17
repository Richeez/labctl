#!/usr/bin/env bash

###############################################################################
# LABCTL Configuration Manager
###############################################################################



config_install() {

    filesystem_directory "$CONFIG_DIR"

    if [[ ! -f "$CONFIG_FILE" ]]; then

        filesystem_copy \
            "$LABCTL_HOME/config" \
            "$CONFIG_DIR"

        log_success "Configuration created."

    else

        log_info "Existing configuration detected."

    fi

}

install_config_validate() {

    local KEY
    local REQUIRED=(DEFAULT_PROFILE PING_TIMEOUT DNS_TARGET INTERNET_TARGET LOG_LEVEL)

    [[ -f "$CONFIG_FILE" ]] || {

        log_error "Configuration missing."

        return 1

    }

    for KEY in "${REQUIRED[@]}"; do
        grep -q "^${KEY}=" "$CONFIG_FILE" || {
            log_error "Configuration key is missing: $KEY"
            return "$EXIT_CONFIGURATION_ERROR"
        }
    done

    return "$EXIT_SUCCESS"

}

install_config_migrate() {

    local OLD_VERSION

    OLD_VERSION="$(
        grep "^VERSION=" "$CONFIG_FILE" \
            | cut -d'"' -f2
    )"

    [[ "$OLD_VERSION" == "$VERSION" ]] && return 0

    log_info "Migrating configuration..."

    cp \
        "$CONFIG_FILE" \
        "$CONFIG_FILE.bak"

    awk '

        !seen[$1]++

    ' "$CONFIG_FILE" >"$CONFIG_FILE.tmp"

    mv \
        "$CONFIG_FILE.tmp" \
        "$CONFIG_FILE"

    log_success "Configuration migrated."

}

install_config_remove() {

    install_confirm "Remove configuration?" || return 0

    safe_remove "$CONFIG_FILE"

}
