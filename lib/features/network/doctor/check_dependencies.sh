#!/bin/bash

doctor_check_dependencies() {

    doctor_section "Dependencies"

    local REQUIRED=(
        jq
        nmcli
        ip
        ping
        nmap
        VBoxManage
        xmllint
    )

    for BIN in "${REQUIRED[@]}"
    do
        if command -v "$BIN" >/dev/null 2>&1
        then
            doctor_ok "$BIN"
        else
            doctor_fail "$BIN"
        fi
    done

}