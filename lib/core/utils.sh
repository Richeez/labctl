#!/bin/bash

###############################################################################
# Utilities
###############################################################################

# require_root() {

#     [[ "$EUID" -eq 0 ]] || log_error "Please run with sudo."

# }

require_root() {

    if [[ $EUID -ne 0 ]]
    then
        log_error "Please run with sudo."
        exit 1
    fi

}

command_exists() {

    command -v "$1" >/dev/null 2>&1

}

require_command() {

    command_exists "$1" || log_error "$1 not installed."

}

validate_dependencies() {

    local REQUIRED=(

        bash
        awk
        grep
        sed
        ip
        nmcli
        ping
        curl
        nmap
        systemctl

    )

    for CMD in "${REQUIRED[@]}"

    do

        require_command "$CMD"

    done

}


timestamp() {

    date '+%F %T'

}


value_or_dash() {

    [[ -n "$1" ]] && printf "%s" "$1" || printf "-"
}


###############################################################################
# Progress Step
###############################################################################

# run_step() {

#     local MESSAGE="$1"
#     shift

#     local START END STATUS

#     START=$(date +%s)

#     printf "%-32s" "${MESSAGE}..."

#     "$@"
#     STATUS=$?

#     END=$(date +%s)

#     if (( STATUS == 0 )); then
#         printf "✓ (%ss)\n" "$((END - START))"
#     else
#         printf "✗ (%ss)\n" "$((END - START))"
#     fi

#     return "$STATUS"

# }


install_directories() {

    mkdir -p "$INSTALL_DIR"

    mkdir -p "$CONFIG_DIR"

    mkdir -p "$CACHE_DIR"

    mkdir -p "$STATE_DIR"

    mkdir -p "$LOG_DIR"

}

install_application() {

    log_info "Copying project..."

    safe_remove "$INSTALL_DIR"

    mkdir -p "$INSTALL_DIR"

    rsync \
        -a \
        --delete \
        --exclude-from="$INSTALL_IGNORE" \
        "$PROJECT_ROOT/" \
        "$INSTALL_DIR/"

}

# install_application() {

#     local SOURCE="$PROJECT_ROOT"
#     local DESTINATION="$INSTALL_DIR"

#     safe_remove "$DESTINATION"

#     mkdir -p "$DESTINATION"

#     local RSYNC_ARGS=()
#     local ITEM

#     for ITEM in "${INSTALL_EXCLUDES[@]}"; do
#         RSYNC_ARGS+=(--exclude="$ITEM/")
#     done

#     rsync -a \
#         "${RSYNC_ARGS[@]}" \
#         "$SOURCE/" \
#         "$DESTINATION/"

# }


install_launcher() {

cat > "$BIN_LINK" <<EOF
#!/usr/bin/env bash

exec "$INSTALL_DIR/bin/labctl" "\$@"

EOF

    chmod 755 "$BIN_LINK"

}

verify_installation() {

    command -v labctl >/dev/null || return 1

    [[ -x "$INSTALL_DIR/bin/labctl" ]] || return 1

    labctl version >/dev/null

}


verify_install_modules() {

    local REQUIRED_FUNCTION

    local REQUIRED_FUNCTIONS=(
        dependencies_check
        directories_create
        install_application
        install_launcher
        completion_install
        settings_create
        permissions_fix
        system_verify
    )

    for REQUIRED_FUNCTION in "${REQUIRED_FUNCTIONS[@]}"; do

        if ! declare -F "$REQUIRED_FUNCTION" >/dev/null; then

            log_error "Required installation function not loaded: $REQUIRED_FUNCTION"

            return "$EXIT_CONFIGURATION_ERROR"

        fi

    done

}

install_configuration() {

    if [[ ! -f "$CONFIG_DIR/config.conf" ]]; then

        cp \
            "$PROJECT_ROOT/config/default.conf" \
            "$CONFIG_DIR/config.conf"

    fi

}

bootstrap_load_dir() {
    local dir="$1"

    local file

    while IFS= read -r file; do
        # shellcheck source=/dev/null
        source "$file"
    done < <(find "$dir" -maxdepth 1 -name "*.sh" | sort)
}

safe_remove() {

    local TARGET="$1"

    [[ -n "$TARGET" ]] || return 1

    [[ "$TARGET" != "/" ]] || return 1

    [[ "$TARGET" != "/home" ]] || return 1

    [[ "$TARGET" != "/etc" ]] || return 1

    rm -rf "$TARGET"

}

verify_install_directory() {

    [[ -d "$INSTALL_DIR" ]] || {

        log_error "Installation directory missing."

        return 1

    }

    log_success "Installation directory."

}

verify_launcher() {

    [[ -L "$BIN_LINK" ]] || {

        log_error "Launcher missing."

        return 1

    }

    log_success "Launcher."

}

verify_configuration() {

    [[ -f "$CONFIG_FILE" ]] || {

        log_error "Configuration missing."

        return 1

    }

    config_validate

}

verify_cache() {

    [[ -d "$CACHE_DIR" ]] || {

        log_error "Cache missing."

        return 1

    }

    log_success "Cache."

}

verify_state() {

    [[ -d "$STATE_DIR" ]] || {

        log_error "State missing."

        return 1

    }

    log_success "Runtime state."

}


uninstall_application() {

    tac "$MANIFEST" |
    while read -r FILE
    do

        safe_remove "$FILE"

    done

}

verify_manifest() {

    [[ -f "$MANIFEST" ]] || {

        log_error "Manifest missing."

        return 1

    }

    log_success "Manifest."

}

verify_version() {

    [[ -f "$VERSION_FILE" ]] || {

        log_error "Version file missing."

        return 1

    }

    local INSTALLED

    INSTALLED="$(installed_version)"

    [[ "$INSTALLED" == "$VERSION" ]] || {

        log_error "Version mismatch."

        return 1

    }

    log_success "Version."

}

verify_binary() {

    command -v labctl >/dev/null 2>&1 || {

        log_error "Executable missing."

        return 1

    }

    labctl version >/dev/null 2>&1 || {

        log_error "Executable not working."

        return 1

    }

    log_success "Executable."

}

verify_permissions() {

    [[ -x "$INSTALL_DIR/bin/labctl" ]] || {

        log_error "Executable permission missing."

        return 1

    }

    log_success "Permissions."

}

verify_summary() {

    echo

    log_success "Installation verified."

}