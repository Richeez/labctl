#!/usr/bin/env bash

source "$(dirname "$0")/../lib/core/bootstrap.sh"

log_info "Logger test"

[[ -f "$LOG_FILE" ]]