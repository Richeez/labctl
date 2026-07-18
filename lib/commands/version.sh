#!/bin/bash

###############################################################################
# VERSION
###############################################################################

run() {

    echo
    echo "$NAME"
    echo
    echo "Version : $VERSION"
    echo
    echo "Configuration : /etc/labctl/config.json"
    echo "State : /var/lib/labctl/state.json"
    echo "Log : $LOG_FILE"
    echo

}