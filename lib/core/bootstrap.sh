#!/usr/bin/env bash

###############################################################################
# LABCTL Bootstrap
#
# Initializes the application and loads every library module.
###############################################################################

# Allow library consumers (including tests) to source bootstrap directly.
if [[ -z "${LABCTL_HOME:-}" ]]; then
    # shellcheck source=home.sh
    source "$(dirname "${BASH_SOURCE[0]}")/home.sh"
fi

###############################################################################
# Bootstrap Exit Codes
###############################################################################

readonly BOOTSTRAP_SUCCESS=0
readonly BOOTSTRAP_FAILURE=1
readonly BOOTSTRAP_INVALID_ARGUMENT=2

###############################################################################
# LABCTL Bootstrap / Module Loader
###############################################################################

###############################################################################
# Require Module
#
# Loads a required library file.
#
# Returns:
#   BOOTSTRAP_SUCCESS
#   BOOTSTRAP_FAILURE
###############################################################################

bootstrap_require() {

    local file="$1"


    ###########################################################################
    # Validate argument
    ###########################################################################

    if [[ -z "$file" ]]; then

        log_error "No bootstrap library specified."

        return "$BOOTSTRAP_INVALID_ARGUMENT"

    fi


    ###########################################################################
    # Validate file
    ###########################################################################

    if [[ ! -f "$file" ]]; then

        log_error "Missing bootstrap library:"
        log_error "  $file"

        return "$BOOTSTRAP_FAILURE"

    fi


    ###########################################################################
    # Load module
    ###########################################################################

    if ! source "$file"; then

        log_error "Failed to load bootstrap library:"
        log_error "  $file"

        return "$BOOTSTRAP_FAILURE"

    fi


    return "$BOOTSTRAP_SUCCESS"
}


###############################################################################
# Load Directory
#
# Loads all shell modules from a directory in deterministic order.
#
# Missing directories are treated as optional.
#
# Returns:
#   EXIT_SUCCESS
#   EXIT_FAILURE
###############################################################################

load_directory() {

    local directory="$1"
    local file


    ###########################################################################
    # Optional directory
    ###########################################################################

    [[ -d "$directory" ]] || return "$BOOTSTRAP_SUCCESS"


    ###########################################################################
    # Load modules
    ###########################################################################

    while IFS= read -r file; do

        #######################################################################
        # Never load bootstrap recursively
        #######################################################################

        [[ "$file" == "$LABCTL_HOME/lib/core/bootstrap.sh" ]] && continue


        #######################################################################
        # Load module
        #######################################################################

        bootstrap_require "$file" || {

            log_error "Failed loading module:"
            log_error "  $file"

            return "$BOOTSTRAP_FAILURE"

        }

    done < <(
        find "$directory" \
            -maxdepth 1 \
            -type f \
            -name "*.sh" \
            -print |
        sort
    )


    return "$BOOTSTRAP_SUCCESS"
}


###############################################################################
# Load modules
###############################################################################
load_directory "$LABCTL_HOME/config" || return "$BOOTSTRAP_FAILURE"
load_directory "$LABCTL_HOME/lib/ui" || return "$BOOTSTRAP_FAILURE"
load_directory "$LABCTL_HOME/lib/core" || return "$BOOTSTRAP_FAILURE"
load_directory "$LABCTL_HOME/lib/system" || return "$BOOTSTRAP_FAILURE"
load_directory "$LABCTL_HOME/lib/network" || return "$BOOTSTRAP_FAILURE"
load_directory "$LABCTL_HOME/lib/cache" || return "$BOOTSTRAP_FAILURE"
load_directory "$LABCTL_HOME/lib/lab" || return "$BOOTSTRAP_FAILURE"
load_directory "$LABCTL_HOME/lib/providers" || return "$BOOTSTRAP_FAILURE"
load_directory "$LABCTL_HOME/lib/services" || return "$BOOTSTRAP_FAILURE"
load_directory "$LABCTL_HOME/lib/install" || return "$BOOTSTRAP_FAILURE"

settings_load

# verify_install_modules || return $?


mkdir -p "$LOG_DIR"

###############################################################################
# Prevent multiple imports
###############################################################################

export BOOTSTRAPPED=1
