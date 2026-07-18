#!/usr/bin/env bash

###############################################################################
# BRIDGED MODE
###############################################################################



run() {

    require_root

    warn "This connects the VM to your physical network."

    read -rp "Continue? (y/N): " ANSWER

    case "${ANSWER,,}" in
        y|yes)
            ;;
        *)
            info "Cancelled."
            exit 0
            ;;
    esac

    network_bridged

    info "Bridged mode enabled."

}

# run() {

#     require_root

#     banner

#     warn "This exposes the VM to your LAN."

#     read -rp "Continue? (YES/yes/y): " ANSWER

#     case "${ANSWER,,}" in
#         y|yes)
#             ;;
#         *)
#             exit 0
#             ;;
#     esac

#     network_service_switch bridged

#     network_service_verify

#     verify_dns

#     verify_internet

#     success "Bridged networking ready."

# }

# run() {

#     require_root

#     banner

#     echo
#     warn "WARNING"
#     echo
#     warn "This connects your VM to the physical LAN."
#     echo

#     read -rp "Continue? (YES/yes/y): " ANSWER

#     case "${ANSWER,,}" in
#         y|yes)
#             ;;
#         *)
#             warn "Operation cancelled."
#             exit 0
#             ;;
#     esac

#     activate_connection bridged

#     verify_network "$(default_interface)"

#     verify_dns

#     verify_internet

#     success "Bridged mode enabled."

# }