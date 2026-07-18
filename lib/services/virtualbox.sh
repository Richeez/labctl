#!/bin/bash

###############################################################################
# VirtualBox Service
###############################################################################

virtualbox_service_list() {

    vbox_exists || fatal "VirtualBox not installed."

    vbox_list_vms

}

virtualbox_service_running() {

    vbox_running_vms

}

virtualbox_service_info() {

    local VM="$1"

    vbox_vm_info "$VM"

}

virtualbox_service_start() {

    local VM="$1"

    vbox_start "$VM"

}

virtualbox_service_stop() {

    local VM="$1"

    vbox_stop "$VM"

}