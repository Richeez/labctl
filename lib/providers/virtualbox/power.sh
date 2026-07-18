###############################################################################
# Power Management
###############################################################################

vbox_start() {

    local VM="$1"

    VBoxManage startvm "$VM" --type headless

    event_emit "VM_STARTED" "$VM"

}

vbox_stop() {

    local VM="$1"

    VBoxManage controlvm "$VM" acpipowerbutton
    
    event_emit "VM_STOPPED" "$VM"

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
