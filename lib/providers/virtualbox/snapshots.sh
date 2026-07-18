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

