#!/usr/bin/env bash

###############################################################################
# LABCTL Progress Engine
###############################################################################

_PROGRESS_CURRENT=0
_PROGRESS_TOTAL=1
_PROGRESS_WIDTH=24

###############################################################################

progress_init() {

    _PROGRESS_CURRENT=0
    _PROGRESS_TOTAL="$1"

}

###############################################################################

progress_percent() {

    echo $(( _PROGRESS_CURRENT * 100 / _PROGRESS_TOTAL ))

}

###############################################################################

progress_draw() {

    local PERCENT
    local FILLED
    local EMPTY

    PERCENT="$(progress_percent)"

    FILLED=$(( PERCENT * _PROGRESS_WIDTH / 100 ))
    EMPTY=$(( _PROGRESS_WIDTH - FILLED ))

    printf "\r["

    printf "%0.s█" $(seq 1 "$FILLED")

    printf "%0.s░" $(seq 1 "$EMPTY")

    printf "] %3d%%" "$PERCENT"

}

###############################################################################

progress_step() {

    ((_PROGRESS_CURRENT++))

    progress_draw

}

###############################################################################

progress_finish() {

    _PROGRESS_CURRENT=$_PROGRESS_TOTAL

    progress_draw

    echo

}

###############################################################################
# UI Step Runner
###############################################################################

ui_run_step() {

    local MESSAGE="$1"

    shift

    progress_step

    if "$@" >/dev/null 2>&1
    then

        printf "\r"

        printf "%-35s" "$MESSAGE"

        log_inline_success

        return 0

    fi

    printf "\r"

    printf "%-35s" "$MESSAGE"

    log_inline_error

    return 1

}



# ###############################################################################
# # Progress UI
# ###############################################################################

# PROGRESS_WIDTH=24

# progress_draw() {

#     local current="$1"
#     local total="$2"
#     local message="$3"

#     local percent=$(( current * 100 / total ))
#     local filled=$(( current * PROGRESS_WIDTH / total ))
#     local empty=$(( PROGRESS_WIDTH - filled ))

#     printf "\r["

#     printf "%0.s█" $(seq 1 "$filled")

#     printf "%0.s░" $(seq 1 "$empty")

#     printf "] %3d%% %s" \
#         "$percent" \
#         "$message"

# }

# ###############################################################################

# progress_clear() {

#     printf "\r"

#     printf "%-120s" ""

#     printf "\r"

# }

# ###############################################################################

# progress_success() {

#     local current="$1"
#     local total="$2"
#     local message="$3"

#     progress_clear

#     printf "✓ [%d/%d] %s\n" \
#         "$current" \
#         "$total" \
#         "$message"

# }

# ###############################################################################

# progress_failed() {

#     local current="$1"
#     local total="$2"
#     local message="$3"

#     progress_clear

#     printf "✗ [%d/%d] %s\n" \
#         "$current" \
#         "$total" \
#         "$message"

# }