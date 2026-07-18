#!/bin/bash

###############################################################################
# VirtualBox Provider
#
# Responsible for interacting with VBoxManage.
###############################################################################

vbox_exists() {

    command -v VBoxManage >/dev/null 2>&1

}

vbox_version() {

    VBoxManage --version

}

vbox_list_vms() {

    VBoxManage list vms

}

vbox_running_vms() {

    VBoxManage list runningvms

}

vbox_vm_exists() {

    local VM="$1"

    VBoxManage list vms | grep -F "\"$VM\"" >/dev/null

}

vbox_vm_info() {

    local VM="$1"

    VBoxManage showvminfo "$VM" --machinereadable

}
