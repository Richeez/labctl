#!/bin/bash

###############################################################################
# Logging Engine
###############################################################################


mkdir -p "$LOG_DIR"

timestamp() {
    date "+%Y-%m-%d %H:%M:%S"
}

log() {
    local LEVEL="$1"
    shift

    printf "[%s] [%s] %s\n" \
        "$(timestamp)" \
        "$LEVEL" \
        "$*" >> "$LOG_FILE"
}

info() {
    echo -e "${BLUE}[INFO] $*${RESET}"
    log INFO "$@"
}

warn() {
    echo -e "${YELLOW}[WARN] $*${RESET}"
    log WARN "$@"
}

error() {
    echo -e "${RED}[ERROR] $*${RESET}" >&2
    log ERROR "$@"
}

success() {
    echo -e "${GREEN}[SUCCESS] $*${RESET}"
    log SUCCESS "$@"
}

fatal() {
    error "$@"
    exit 1
}


# mkdir -p "$(dirname "$LOG_FILE")"

# touch "$LOG_FILE"

# log() {

#     local LEVEL="$1"

#     shift

#     printf "[%s] [%s] %s\n" \
#         "$(date '+%F %T')" \
#         "$LEVEL" \
#         "$*" >> "$LOG_FILE"

# }

# info() {

#     echo "[INFO] $*"

#     log INFO "$*"

# }

# warn() {

#     echo "[WARN] $*"

#     log WARN "$*"

# }

# error() {

#     echo "[ERROR] $*"

#     log ERROR "$*"

# }

# success() {

#     echo "[ OK ] $*"

#     log SUCCESS "$*"

# }

# fatal() {

#     error "$*"

#     exit 1

# }