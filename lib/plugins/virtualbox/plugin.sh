#!/bin/bash

###############################################################################
# VirtualBox Plugin
###############################################################################

plugin_init() {

    info "Loading VirtualBox Plugin"

    register_plugin \
        "virtualbox" \
        "Oracle VirtualBox Integration"

    source "$LABCTL_HOME/lib/plugins/virtualbox/providers.sh"

    source "$LABCTL_HOME/lib/plugins/virtualbox/events.sh"

    source "$LABCTL_HOME/lib/plugins/virtualbox/commands.sh"

}

plugin_shutdown() {

    info "Stopping VirtualBox Plugin"

}