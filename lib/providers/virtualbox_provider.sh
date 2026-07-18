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


###############################################################################
# Virtual Network Information
###############################################################################

vbox_vm_networks() {

    local VM="$1"

    VBoxManage showvminfo "$VM" --machinereadable |
    awk -F= '

        /^nic[1-9]/ {

            gsub("\"","",$2)

            NIC=$2

        }

        /^nictype[1-9]/ {

            gsub("\"","",$2)

            TYPE=$2

        }

        /^hostonlyadapter[1-9]/ {

            gsub("\"","",$2)

            HOST=$2

        }

        /^bridgeadapter[1-9]/ {

            gsub("\"","",$2)

            BRIDGE=$2

        }

        /^nat-network[1-9]/ {

            gsub("\"","",$2)

            NATNET=$2

        }

        END{

        }

    '

}



###############################################################################
# Power Management
###############################################################################

vbox_start() {

    local VM="$1"

    VBoxManage startvm "$VM" --type headless

}

vbox_stop() {

    local VM="$1"

    VBoxManage controlvm "$VM" acpipowerbutton

}

vbox_poweroff() {

    local VM="$1"

    VBoxManage controlvm "$VM" poweroff

}

vbox_pause() {

    local VM="$1"

    VBoxManage controlvm "$VM" pause

}

vbox_resume() {

    local VM="$1"

    VBoxManage controlvm "$VM" resume

}




###############################################################################
# Snapshot Manager
###############################################################################

vbox_snapshots() {

    local VM="$1"

    VBoxManage snapshot "$VM" list

}

vbox_snapshot_take() {

    local VM="$1"

    local NAME="$2"

    VBoxManage snapshot "$VM" take "$NAME"

}

vbox_snapshot_restore() {

    local VM="$1"

    local NAME="$2"

    VBoxManage snapshot "$VM" restore "$NAME"

}

vbox_snapshot_delete() {

    local VM="$1"

    local NAME="$2"

    VBoxManage snapshot "$VM" delete "$NAME"

}



###############################################################################
# Clone Manager
###############################################################################

vbox_clone() {

    local SOURCE="$1"

    local DEST="$2"

    VBoxManage clonevm \
        "$SOURCE" \
        --name "$DEST" \
        --register

}