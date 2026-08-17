#!/usr/bin/env bash

###############################################################################
# BRIDGED MODE
###############################################################################



run() {

    require_root

    log_warning "This connects the VM to your physical network."

    read -rp "Continue? (y/N): " ANSWER

    case "${ANSWER,,}" in
        y|yes)
            ;;
        *)
            log_info "Cancelled."
            return "$EXIT_SUCCESS"
            ;;
    esac

    cache_ensure || {
        log_error "Unable to initialize cache."
        return "$EXIT_FAILURE"
    }

    network_bridged

    # info "Bridged mode enabled."

}
