#!/bin/bash

###############################################################################
# UPDATE MODE
###############################################################################


run() {

    require_root

    banner

    network_service_switch update

    network_service_verify

    verify_dns

    verify_internet

    success "Internet mode ready."

}
# run() {

#     require_root

#     banner

#     activate_connection update

#     verify_network "$(default_interface)"

#     verify_dns

#     verify_internet

#     success "Internet update mode enabled."

# }