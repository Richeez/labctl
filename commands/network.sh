#!/usr/bin/env bash

###############################################################################
# Network Mode Command
###############################################################################

network_mode_run() {

    local MODE="${1:-}"

    case "$MODE" in
        internet|nat|update)
            require_root
            cache_ensure || return "$EXIT_FAILURE"
            network_internet
            ;;
        contain)
            require_root
            cache_ensure || return "$EXIT_FAILURE"
            network_contain
            ;;
        lab)
            require_root
            cache_ensure || return "$EXIT_FAILURE"
            network_lab
            ;;
        bridged)
            require_root
            log_warning "This connects the VM to your physical network."
            read -rp "Continue? (y/N): " ANSWER
            [[ "${ANSWER,,}" == "y" || "${ANSWER,,}" == "yes" ]] || {
                log_info "Cancelled."
                return 0
            }
            cache_ensure || return "$EXIT_FAILURE"
            network_bridged
            ;;
        -h|--help|"")
            cat <<EOF
Usage: labctl network <mode>

Modes:
  internet (or nat)  Enable Internet access through NAT
  contain            Switch to NAT Network containment mode
  lab                Switch to the host-only laboratory
  bridged            Connect to the physical LAN
EOF
            ;;
        *)
            log_error "Unknown network mode: $MODE"
            return "$EXIT_INVALID_ARGUMENT"
            ;;
    esac

}

run() {

    network_mode_run "$@"

}
