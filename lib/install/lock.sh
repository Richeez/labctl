#!/usr/bin/env bash


###############################################################################
# Launcher
###############################################################################

# launcher_install() {

#     filesystem_symlink \
#         "$INSTALL_DIR/bin/labctl" \
#         "$BIN_LINK"

# }

# launcher_remove() {

#     rm -f "$BIN_LINK"

# }

# launcher_verify() {

#     [[ -L "$BIN_LINK" ]]

# }


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

    rm -f "$INSTALL_LOCK"

}

