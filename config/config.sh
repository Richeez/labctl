# config_show() {

#     ui_start "CONFIGURATION"

#     settings_list

#     ui_finish

# }

config_show() {

    ui_start "CONFIGURATION"

    printf "%-28s %-40s\n" "KEY" "VALUE"

    printf "%-28s %-40s\n" \
        "------------------------" \
        "------------------------"

    settings_list | awk -F= '{ printf "%-28s %-40s\n", $1, substr($0, length($1) + 2) }'

    ui_finish

}

config_list() {

    settings_list

}

config_get() {

    local KEY="${1:-}"

    [[ -z "$KEY" ]] && {

        log_error "Usage: labctl config get KEY"

        return 1

    }

    settings_get "$KEY"

}

config_set() {

    local KEY="${1:-}"
    local VALUE="${2:-}"

    [[ -z "$KEY" ]] && {

        log_error "Missing key."

        return 1

    }

    [[ -z "$VALUE" ]] && {

        log_error "Missing value."

        return 1

    }

    settings_set "$KEY" "$VALUE"

    log_success "$KEY updated."

}

config_unset() {

    local KEY="${1:-}"

    [[ -z "$KEY" ]] && {

        log_error "Missing key."

        return 1

    }

    settings_unset "$KEY"

    log_success "$KEY removed."

}

config_reset() {

    if [[ "${1:-}" == "--all" ]]
    then

        settings_reset

        log_success "Configuration reset."

        return

    fi

    log_error "Use 'labctl config reset --all' to restore defaults."
    return "$EXIT_INVALID_ARGUMENT"

}

config_export() {

    local FILE="${1:-}"

    [[ -z "$FILE" ]] && {

        log_error "Specify export file."

        return 1

    }

    settings_export "$FILE"

    log_success "Configuration exported."

}

config_import() {

    local FILE="${1:-}"

    [[ ! -f "$FILE" ]] && {

        log_error "File not found."

        return 1

    }

    settings_import "$FILE"

    log_success "Configuration imported."

}

config_validate() {

    local KEY
    local REQUIRED=(DEFAULT_PROFILE PING_TIMEOUT DNS_TARGET INTERNET_TARGET LOG_LEVEL)

    for KEY in "${REQUIRED[@]}"; do
        if ! grep -q "^${KEY}=" "$CONFIG_FILE" 2>/dev/null; then
            log_error "Missing configuration key: $KEY"
            return "$EXIT_CONFIGURATION_ERROR"
        fi
    done

    log_success "Configuration valid."

}

config_edit() {

    local EDITOR_CMD="${EDITOR:-nano}"

    "$EDITOR_CMD" "$CONFIG_FILE"

    settings_load

}
