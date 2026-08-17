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
        return "$EXIT_PERMISSION_DENIED"
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

    safe_remove "$INSTALL_DIR" || return "$EXIT_FAILURE"

    mkdir -p "$INSTALL_DIR"

    rsync \
        -a \
        --delete \
        --exclude-from="$INSTALL_IGNORE" \
        "$PROJECT_ROOT/" \
        "$INSTALL_DIR/"

}

update_application() {

    local STAGING_DIR="$T_DIR/application"

    [[ -n "$T_DIR" && -d "$T_DIR" ]] || {
        log_error "No active update transaction."
        return "$EXIT_FAILURE"
    }

    # An installed `labctl update` runs from INSTALL_DIR, so stage the source
    # before replacing that directory.
    mkdir -p "$STAGING_DIR" || return "$EXIT_FAILURE"

    rsync \
        -a \
        --delete \
        --exclude-from="$INSTALL_IGNORE" \
        "$PROJECT_ROOT/" \
        "$STAGING_DIR/" || return "$EXIT_FAILURE"

    safe_remove "$INSTALL_DIR" || return "$EXIT_FAILURE"
    mkdir -p "$INSTALL_DIR" || return "$EXIT_FAILURE"

    rsync -a --delete "$STAGING_DIR/" "$INSTALL_DIR/"

}

settings_migrate() {

    # Keep user-managed configuration intact. New defaults are deliberately
    # not merged implicitly because values may contain local network details.
    settings_create

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

    launcher_install

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

###############################################################################
# Validate supported operating system.
###############################################################################

_validate_os() {

    [[ "$OSTYPE" == linux* ]] && return 0

    log_error "Unsupported operating system."

    log_info "LABCTL currently supports Linux only."

    return 1

}

validate_environment() {

    _validate_os || return 1

    _validate_commands || return 1

    _validate_directories || return 1

    _validate_permissions || return 1

    _validate_networkmanager || return 1

}

###############################################################################
# Validate required system commands.
###############################################################################

_validate_commands() {

    local commands=(
        ip
        nmcli
        awk
        grep
        sed
        cut
        tr
        date
        find
        mkdir
        touch
    )

    local command

    for command in "${commands[@]}"; do

        command -v "$command" >/dev/null 2>&1 || {

            log_error "Missing required command: $command"

            return 1

        }

    done

}

###############################################################################
# Validate required directories.
###############################################################################

_validate_directories() {

    [[ -d "$LOG_DIR" ]] && return 0

    log_error "Missing directory: $LOG_DIR"

    return 1

}

###############################################################################
# Validate required permissions.
###############################################################################

_validate_permissions() {

    [[ -w "$LOG_DIR" ]] && return 0

    log_error "Log directory is not writable."

    return 1

}

###############################################################################
# Validate NetworkManager.
###############################################################################

_validate_networkmanager() {

    systemctl is-active --quiet NetworkManager && return 0

    log_error "NetworkManager is not running."

    return 1

}

###############################################################################
# USE LATER
###############################################################################

# CONFIG_FILE="/etc/labctl/config.json"

# if [[ ! -f "$CONFIG_FILE" ]]; then
#     echo "Missing configuration."

#     exit 1
# fi

# VERSION=$(jq -r '.version' "$CONFIG_FILE")

# LOG_LEVEL=$(jq -r '.logging.level' "$CONFIG_FILE")

# LOG_FILE=$(jq -r '.logging.file' "$CONFIG_FILE")

# NAT_DEV=$(jq -r '.interfaces.nat' "$CONFIG_FILE")

# HOSTONLY_DEV=$(jq -r '.interfaces.hostonly' "$CONFIG_FILE")

# BRIDGED_DEV=$(jq -r '.interfaces.bridged' "$CONFIG_FILE")

# CONTAIN_DEV=$(jq -r '.interfaces.contain' "$CONFIG_FILE")

# DHCP_TIMEOUT=$(jq -r '.timeouts.dhcp' "$CONFIG_FILE")

# PING_TIMEOUT=$(jq -r '.timeouts.ping' "$CONFIG_FILE")

# DNS_TARGET=$(jq -r '.network.dns' "$CONFIG_FILE")

# PING_TARGET=$(jq -r '.network.internet_check' "$CONFIG_FILE")

# use cases
# json_set ".mode=\"$TARGET\""
#     json_set ".last_switch=\"$(timestamp)\""
#     json_set ".default_interface=\"$DEVICE\""
# echo "Default Interface : $(default_interface)"
#     echo "Gateway           : $(default_gateway)"
#     echo "Current Mode      : $(json_get '.mode')"
#     echo "Last Switch       : $(json_get '.last_switch')"

# #!/bin/bash

# ###############################################################################
# # LABCTL Installer
# ###############################################################################

# set -euo pipefail

# INSTALL_DIR="/opt/labctl"
# BIN_LINK="/usr/local/bin/labctl"

# echo "=========================================="
# echo "Installing LABCTL..."
# echo "=========================================="

# # Root check
# if [[ "$EUID" -ne 0 ]]; then
#     echo "Please run with sudo."
#     exit 1
# fi

# # Create required directories
# mkdir -p "$INSTALL_DIR"
# mkdir -p /etc/labctl
# mkdir -p /var/log/labctl
# mkdir -p /var/lib/labctl
# mkdir -p /var/cache/labctl

# # Copy project
# cp -R ./* "$INSTALL_DIR"

# # Default configuration
# if [[ ! -f /etc/labctl/config.json ]]; then
#     cp config/default.json /etc/labctl/config.json
# fi

# # Permissions
# find "$INSTALL_DIR" -type f -name "*.sh" -exec chmod +x {} \;
# chmod +x "$INSTALL_DIR/bin/labctl"

# # Symbolic link
# ln -sf "$INSTALL_DIR/bin/labctl" "$BIN_LINK"

# echo
# echo "Installation Complete."
# echo
# echo "Run:"
# echo
# echo "labctl version"


# PROJECT=labctl

# PREFIX=/opt/labctl

# install:
# 	sudo ./install.sh

# uninstall:
# 	sudo ./uninstall.sh

# lint:
# 	shellcheck $$(find . -name "*.sh")

# format:
# 	shfmt -w .

# test:
# 	./tests/run_tests.sh

# coverage:
# 	kcov coverage ./tests/run_tests.sh

# clean:
# 	rm -rf coverage
# 	rm -rf cache

# help:
# 	@echo "make install"
# 	@echo "make uninstall"
# 	@echo "make test"
# 	@echo "make coverage"
# 	@echo "make lint"
# 	@echo "make format"

# FORMATTING

# Install
# sudo snap install shfmt

# LINTING

# Install

# sudo apt install shellcheck
