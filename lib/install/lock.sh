#!/usr/bin/env bash

###############################################################################
# Installer Lock
###############################################################################

readonly INSTALL_LOCK="/tmp/labctl.lock"

lock_acquire() {

    if [[ -f "$INSTALL_LOCK" ]]; then

        local PID

        PID="$(cat "$INSTALL_LOCK")"

        log_error "Installer already running (PID: $PID)."

        return 1

    fi

    printf "%s\n" "$$" > "$INSTALL_LOCK"

}

lock_release() {

    safe_remove "$INSTALL_LOCK"

}

