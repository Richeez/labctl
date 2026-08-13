#!/usr/bin/env bash

###############################################################################
# Runtime State
###############################################################################

state_install() {

    filesystem_directory "$STATE_DIR"

    refresh_state

}

state_update() {

    refresh_state

}

state_remove() {

    filesystem_remove "$STATE_DIR"

}