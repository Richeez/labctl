#!/bin/bash

###############################################################################
# Event Bus
###############################################################################

declare -A LABCTL_EVENT_HANDLERS

event_register() {

    local EVENT="$1"
    local HANDLER="$2"

    LABCTL_EVENT_HANDLERS["$EVENT"]+="$HANDLER "
}

event_emit() {

    local EVENT="$1"
    shift

    local HANDLERS="${LABCTL_EVENT_HANDLERS[$EVENT]}"

    for HANDLER in $HANDLERS
    do
        if declare -F "$HANDLER" >/dev/null; then
            "$HANDLER" "$@"
        fi
    done
}