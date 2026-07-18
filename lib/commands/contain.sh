#!/usr/bin/env bash

###############################################################################
# CONTAIN MODE
###############################################################################




run() {

    require_root

    network_contain

    info "Contain mode enabled."

}

# run() {

#     require_root

#     banner

#     network_service_switch contain

#     network_service_verify

#     success "Contain mode ready."

# }

# run() {

#     require_root

#     banner

#     activate_connection contain

#     verify_network "$(default_interface)"

#     success "Contain mode enabled."

# }