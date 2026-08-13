#!/usr/bin/env bash

###############################################################################
# LABCTL Home
###############################################################################

if [[ -z "${LABCTL_HOME:-}" ]]; then

    LABCTL_HOME="$(
        cd "$(dirname "${BASH_SOURCE[0]}")/../.." &&
        pwd
    )"

    export LABCTL_HOME

fi