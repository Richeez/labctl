#!/bin/bash

###############################################################################
# Default Event Handlers
###############################################################################

on_network_changed() {

    info "Network changed."

    json_set ".last_switch=\"$(timestamp)\""
}

on_vm_started() {

    info "VM started: $1"
}

on_vm_stopped() {

    info "VM stopped: $1"
}

event_register "NETWORK_CHANGED" on_network_changed
event_register "VM_STARTED" on_vm_started
event_register "VM_STOPPED" on_vm_stopped