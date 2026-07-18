#!/bin/bash

###############################################################################
# VirtualBox Events
###############################################################################

virtualbox_network_changed() {

    info "VirtualBox Plugin noticed network change."

}

event_register \
    NETWORK_CHANGED \
    virtualbox_network_changed