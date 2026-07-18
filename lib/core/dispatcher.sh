#!/bin/bash

###############################################################################
# Command Dispatcher
###############################################################################



dispatch() {

    local COMMAND="${1:-help}"

    shift || true

    local FILE

    FILE="$HOME/lib/commands/${COMMAND}.sh"

    if [[ ! -f "$FILE" ]]; then
        fatal "Unknown command: $COMMAND"
    fi

    source "$FILE"

    if ! declare -F run >/dev/null; then
        fatal "Command '$COMMAND' is invalid."
    fi

    run "$@"

}

# dispatch() {

#     local COMMAND="${1:-help}"

#     shift || true

#     local HANDLER

#     HANDLER=$(get_command "$COMMAND")

#     if [[ -n "$HANDLER" ]] &&
#        declare -F "$HANDLER" >/dev/null
#     then

#         "$HANDLER" "$@"

#         return

#     fi

#     local FILE

#     FILE="$HOME/lib/commands/${COMMAND}.sh"

#     if [[ -f "$FILE" ]]
#     then

#         source "$FILE"

#         run "$@"

#         return

#     fi

#     fatal "Unknown command: $COMMAND"

# }

# COMMAND_DIR="$LABCTL_HOME/lib/commands"

# dispatch() {

#     local CMD="${1:-help}"

#     shift || true

#     local FILE="$COMMAND_DIR/${CMD}.sh"

#     if [[ ! -f "$FILE" ]]; then
#         error "Unknown command: $CMD"
#         CMD="help"
#         FILE="$COMMAND_DIR/help.sh"
#     fi

#     source "$FILE"

#     if ! declare -F run >/dev/null; then
#         fatal "Command '$CMD' does not define run()."
#     fi

#     run "$@"
# }