#!/usr/bin/env bash

###############################################################################
# Installer Cache
###############################################################################

cache_install() {

    filesystem_directory "$CACHE_DIR"

    cache_clear

    refresh_state

}

cache_update() {

    cache_rebuild

}

cache_remove() {

    filesystem_remove "$CACHE_DIR"

}