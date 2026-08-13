#!/usr/bin/env bash

###############################################################################
# Version
###############################################################################

VERSION_FILE="$STATE_DIR/version"

version_write() {

    mkdir -p "$STATE_DIR"

    cat > "$VERSION_FILE" <<EOF
VERSION=$VERSION
DATE=$(date +%F)
EOF

}

installed_version() {

    [[ -f "$VERSION_FILE" ]] || return 1

    grep "^VERSION=" "$VERSION_FILE" \
        | cut -d= -f2

}

version_matches() {

    [[ "$(installed_version)" == "$VERSION" ]]

}