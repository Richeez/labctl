#!/usr/bin/env bash

###############################################################################
# LABCTL Logger
#
# Provides:
#   - Timestamped logging
#   - Colored terminal output
#   - Automatic log file writing
#   - Multiple log levels
###############################################################################

###############################################################################
# Internal Helpers
###############################################################################

logger_timestamp() {

    date "$LOG_DATE_FORMAT"

}

logger_write_file() {

    local level="$1"
    shift

    local message="$*"

    printf "[%s] [%s] %s\n" \
        "$(logger_timestamp)" \
        "$level" \
        "$message" \
        >> "$LOG_FILE"

}

logger_print() {

    local color="$1"
    local level="$2"

    shift 2

    local message="$*"

    printf "%b[%s] [%s] %s%b\n" \
        "${color:-}" \
        "$(logger_timestamp)" \
        "$level" \
        "$message" \
        "${NC:-}"

    logger_write_file "$level" "$message"

}

###############################################################################
# Public Logging Functions
###############################################################################

log_info() {

    logger_print "$BLUE" "INFO" "$@"

}

log_success() {

    logger_print "$GREEN" "SUCCESS" "$@"

}

log_warning() {

    logger_print "$YELLOW" "WARNING" "$@"

}

log_error() {

    logger_print "$RED" "ERROR" "$@" >&2

}

log_debug() {

    [[ "${DEBUG:-0}" == "1" ]] || return

    logger_print "$CYAN" "DEBUG" "$@"

}

###############################################################################
# Banner
###############################################################################

log_banner() {

    echo

    printf "%b========== %s ==========%b\n" \
        "${BLUE:-}" \
        "$1" \
        "${NC:-}"

}

###############################################################################
# Divider
###############################################################################

log_divider() {

    printf "%b------------------------------------------------------------%b\n" \
        "${CYAN:-}" \
        "${NC:-}"

}

# timestamp() {
#     date "+%Y-%m-%d %H:%M:%S"
# }

# log() {
#     local LEVEL="$1"
#     shift

#     printf "[%s] [%s] %s\n" \
#         "$(timestamp)" \
#         "$LEVEL" \
#         "$*" >> "$LOG_FILE"
# }

# info() {
#     echo -e "${BLUE}[INFO] $*${RESET}"
#     log INFO "$@"
# }

# warn() {
#     echo -e "${YELLOW}[WARN] $*${RESET}"
#     log WARN "$@"
# }

# error() {
#     echo -e "${RED}[ERROR] $*${RESET}" >&2
#     log ERROR "$@"
# }

# success() {
#     echo -e "${GREEN}[SUCCESS] $*${RESET}"
#     log SUCCESS "$@"
# }

# fatal() {
#     error "$@"
#     exit 1
# }


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