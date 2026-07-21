#!/usr/bin/env bash

###############################################################################
# LABCTL Bootstrap
#
# Initializes the application and loads every library module.
###############################################################################


###############################################################################
# Resolve project root
###############################################################################


###############################################################################
# Load helper
###############################################################################

load_directory() {

    local directory="$1"

    [[ -d "$directory" ]] || return

    while IFS= read -r file
do
    [[ "$file" == "$LABCTL_HOME/lib/core/bootstrap.sh" ]] && continue
    source "$file"
done < <(find "$directory" -maxdepth 1 -type f -name "*.sh" | sort)

}

###############################################################################
# Load modules
###############################################################################

load_directory "$LABCTL_HOME/lib/ui"

load_directory "$LABCTL_HOME/lib/core"

load_directory "$LABCTL_HOME/lib/network"

mkdir -p "$LOG_DIR"

###############################################################################
# Prevent multiple imports
###############################################################################

export BOOTSTRAPPED=1