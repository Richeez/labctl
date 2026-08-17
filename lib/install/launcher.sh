#!/usr/bin/env bash

###############################################################################
# Launcher
###############################################################################

# launcher_install() {

#     filesystem_link \
#         "$INSTALL_DIR/bin/labctl" \
#         "$BIN_LINK"

# }

launcher_install() {

    mkdir -p "$BIN_DIR" || {

        log_error "Failed to create launcher directory: $BIN_DIR"

        return "$EXIT_FAILURE"

    }


    if [[ -e "$BIN_LINK" || -L "$BIN_LINK" ]]; then

        rm -f "$BIN_LINK" || {

            log_error "Failed to remove existing launcher: $BIN_LINK"

            return "$EXIT_FAILURE"

        }

    fi


    filesystem_symlink \
        "$INSTALL_DIR/bin/labctl" \
        "$BIN_LINK" || {

        log_error "Failed to create launcher: $BIN_LINK"

        return "$EXIT_FAILURE"

    }


    return "$EXIT_SUCCESS"
}



launcher_remove() {

    rm -f "$BIN_LINK"

}

launcher_verify() {

    [[ -L "$BIN_LINK" ]] || return "$EXIT_FAILURE"
    [[ "$(readlink -f "$BIN_LINK" 2>/dev/null)" == "$INSTALL_DIR/bin/labctl" ]]

}
