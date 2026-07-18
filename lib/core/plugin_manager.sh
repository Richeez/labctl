#!/bin/bash

###############################################################################
# Plugin Loader
###############################################################################

PLUGIN_DIR="$LABCTL_HOME/lib/plugins"

plugin_load_all() {

    [[ -d "$PLUGIN_DIR" ]] || return

    for DIR in "$PLUGIN_DIR"/*
    do
        [[ -d "$DIR" ]] || continue

        local ENTRY="$DIR/plugin.sh"

        [[ -f "$ENTRY" ]] || continue

        source "$ENTRY"

        if declare -F plugin_init >/dev/null
        then
            plugin_init
        fi
    done
}

plugin_shutdown_all() {

    for DIR in "$PLUGIN_DIR"/*
    do
        [[ -d "$DIR" ]] || continue

        local ENTRY="$DIR/plugin.sh"

        [[ -f "$ENTRY" ]] || continue

        source "$ENTRY"

        if declare -F plugin_shutdown >/dev/null
        then
            plugin_shutdown
        fi
    done
}