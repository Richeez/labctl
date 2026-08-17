#!/usr/bin/env bash

###############################################################################
# LABCTL Installation Verification
###############################################################################

verify_install_directory() {

    [[ -d "$INSTALL_DIR" ]] || {
        log_error "Application directory missing: $INSTALL_DIR"
        return "$EXIT_FAILURE"
    }

    return 0
}


verify_binary() {

    local BINARY="$INSTALL_DIR/bin/labctl"

    [[ -f "$BINARY" ]] || {
        log_error "LABCTL executable missing: $BINARY"
        return "$EXIT_FAILURE"
    }

    [[ -x "$BINARY" ]] || {
        log_error "LABCTL executable is not executable."
        return "$EXIT_FAILURE"
    }

    return 0
}


verify_launcher() {

    [[ -L "$BIN_LINK" ]] || {
        log_error "Launcher is missing: $BIN_LINK"
        return "$EXIT_FAILURE"
    }

    local TARGET

    TARGET="$(readlink -f "$BIN_LINK" 2>/dev/null || true)"

    [[ "$TARGET" == "$INSTALL_DIR/bin/labctl" ]] || {
        log_error "Launcher points to an unexpected target."
        return "$EXIT_FAILURE"
    }

    return 0
}


verify_configuration() {

    [[ -f "$CONFIG_FILE" ]] || {
        log_error "Configuration is missing: $CONFIG_FILE"
        return "$EXIT_CONFIGURATION_ERROR"
    }

    install_config_validate

}


verify_cache() {

    [[ -d "$CACHE_DIR" ]] || {
        log_error "Cache directory missing: $CACHE_DIR"
        return "$EXIT_FAILURE"
    }

    return 0
}


verify_state() {

    [[ -d "$STATE_DIR" ]] || {
        log_error "State directory missing: $STATE_DIR"
        return "$EXIT_FAILURE"
    }

    return 0
}


verify_manifest() {

    manifest_exists || {
        log_error "Installation manifest missing."
        return "$EXIT_FAILURE"
    }

    return 0
}


verify_version() {

    version_matches || {
        log_error "Installed version does not match configured version."
        return "$EXIT_FAILURE"
    }

    return 0
}


verify_permissions() {

    permission_verify || {
        log_error "Application permissions are invalid."
        return "$EXIT_PERMISSION_DENIED"
    }

    return 0
}


verify_installation() {

    local FAILED=0

    verify_install_directory || ((FAILED++))
    verify_binary            || ((FAILED++))
    verify_launcher          || ((FAILED++))
    verify_configuration     || ((FAILED++))
    verify_cache             || ((FAILED++))
    verify_state             || ((FAILED++))
    verify_manifest          || ((FAILED++))
    verify_version           || ((FAILED++))
    verify_permissions       || ((FAILED++))

    if (( FAILED > 0 )); then
        log_error "$FAILED installation verification check(s) failed."
        return "$EXIT_FAILURE"
    fi

    return 0
}


###############################################################################
# Removal Verification
###############################################################################

verify_application_removed() {

    [[ ! -e "$INSTALL_DIR" ]] || {
        log_error "Application directory still exists."
        return 1
    }

}


verify_launcher_removed() {

    [[ ! -e "$BIN_LINK" && ! -L "$BIN_LINK" ]] || {
        log_error "Launcher still exists."
        return 1
    }

}


verify_removal() {

    local FAILED=0

    verify_application_removed || ((FAILED++))
    verify_launcher_removed    || ((FAILED++))

    if (( FAILED > 0 )); then
        log_error "$FAILED removal verification check(s) failed."
        return 1
    fi

    return 0
}
