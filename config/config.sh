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

    local KEY

    for KEY in "${!SETTINGS[@]}"
    do

        printf "%-28s %-40s\n" \
            "$KEY" \
            "${SETTINGS[$KEY]}"

    done

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

    settings_save

    log_success "$KEY updated."

}

config_unset() {

    local KEY="${1:-}"

    [[ -z "$KEY" ]] && {

        log_error "Missing key."

        return 1

    }

    settings_unset "$KEY"

    settings_save

    log_success "$KEY removed."

}

config_reset() {

    if [[ "${1:-}" == "--all" ]]
    then

        settings_reset_all

        log_success "Configuration reset."

        return

    fi

    local KEY="$1"

    settings_reset "$KEY"

    log_success "$KEY reset."

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

    if settings_validate
    then

        log_success "Configuration valid."

    else

        log_error "Configuration invalid."

        return 1

    fi

}

config_edit() {

    local EDITOR_CMD="${EDITOR:-nano}"

    "$EDITOR_CMD" "$CONFIG_FILE"

    settings_reload

}