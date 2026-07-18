#!/bin/bash

###############################################################################
# Logging Engine
###############################################################################

mkdir -p "$(dirname "$LOG_FILE")"

touch "$LOG_FILE"

log() {

    local LEVEL="$1"

    shift

    printf "[%s] [%s] %s\n" \
        "$(date '+%F %T')" \
        "$LEVEL" \
        "$*" >> "$LOG_FILE"

}

info() {

    echo "[INFO] $*"

    log INFO "$*"

}

warn() {

    echo "[WARN] $*"

    log WARN "$*"

}

error() {

    echo "[ERROR] $*"

    log ERROR "$*"

}

success() {

    echo "[ OK ] $*"

    log SUCCESS "$*"

}

fatal() {

    error "$*"

    exit 1

}