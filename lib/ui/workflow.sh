#!/usr/bin/env bash

###############################################################################
# Workflow Engine
###############################################################################

WORKFLOW_TOTAL=0
WORKFLOW_CURRENT=0

###############################################################################

workflow_begin() {

    local WORKFLOW_NAME="$1"
    local CONTINUE_ON_ERROR="${2:-false}"

    local -n STEPS="$WORKFLOW_NAME"

    WORKFLOW_TOTAL="${#STEPS[@]}"
    WORKFLOW_CURRENT=0

    progress_init "$WORKFLOW_TOTAL"

    local STEP
    local MESSAGE
    local FUNCTION
    local FAILED=0

    for STEP in "${STEPS[@]}"
    do

        IFS=":" read -r MESSAGE FUNCTION <<< "$STEP"

        if ! workflow_run "$MESSAGE" "$FUNCTION"; then

            FAILED=1

            if [[ "$CONTINUE_ON_ERROR" != true ]]; then

                progress_finish

                return 1

            fi

        fi

    done

    progress_finish

    return "$FAILED"

}

workflow_run() {

    local MESSAGE="$1"

    local FUNCTION="$2"

    local START
    local END

    START=$(date +%s)

    progress_step

    if "$FUNCTION"
    then

        END=$(date +%s)

        printf "\r"

        printf "%-35s" "$MESSAGE"

        printf "✓ (%ss)\n" "$((END - START))"

        return 0

    fi

    printf "\r"

    printf "%-35s" "$MESSAGE"

    log_inline_error

    return 1

}