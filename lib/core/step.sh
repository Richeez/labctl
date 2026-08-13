#!/usr/bin/env bash

run_step() {

    local STEP="$1"
    local TOTAL="$2"
    local MESSAGE="$3"

    shift 3

    progress_draw \
        "$STEP" \
        "$TOTAL" \
        "$MESSAGE"

    if "$@"
    then

        progress_success \
            "$STEP" \
            "$TOTAL" \
            "$MESSAGE"

        return 0

    fi

    progress_failed \
        "$STEP" \
        "$TOTAL" \
        "$MESSAGE"

    return 1

}