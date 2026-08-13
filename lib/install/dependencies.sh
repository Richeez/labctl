#!/usr/bin/env bash

###############################################################################
# Dependency Manager
###############################################################################

dependency_exists() {

    command -v "$1" >/dev/null 2>&1

}

dependencies_check() {

    local CMD

    for CMD in "${REQUIRED_COMMANDS[@]}"
    do

        dependency_exists "$CMD" || {

            log_error "Missing dependency: $CMD"

            return 1

        }

    done

}

# dependency_check() {

#     local FAILED=0
#     local COMMAND

#     for COMMAND in "${REQUIRED_COMMANDS[@]}"
#     do

#         if dependency_exists "$COMMAND"; then

#             log_success "$COMMAND"

#         else

#             log_error "$COMMAND"

#             ((FAILED++))

#         fi

#     done

#     ((FAILED == 0))

# }