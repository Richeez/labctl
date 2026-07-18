#!/bin/bash

###############################################################################
# HOST-ONLY LAB MODE
###############################################################################



run() {

    require_root

    banner

    network_service_switch lab

    network_service_verify

    success "Host-only lab ready."

}

# run() {

#     require_root

#     banner

#     activate_connection lab

#     verify_network "$(default_interface)"

#     success "Host-only lab enabled."

# }