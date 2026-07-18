
#!/usr/bin/env bash


set -euo pipefail

LABCTL_HOME="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Load configuration first
source "$LABCTL_HOME/lib/core/config.sh"

# Load UI
source "$LABCTL_HOME/lib/ui/colors.sh"

# Load core modules
for file in "$LABCTL_HOME"/lib/core/*.sh
do
    [[ "$file" == *bootstrap.sh ]] && continue
    source "$file"
done

# Load network modules
for file in "$LABCTL_HOME"/lib/network/*.sh
do
    source "$file"
done

# for FILE in "$HOME"/lib/core/events.sh
# do
#     source "$FILE"
# done

# ###############################################################
# # Providers
# ###############################################################

# for FILE in "$HOME"/lib/providers/*.sh
# do
#     source "$FILE"
# done



# ###############################################################
# # Services
# ###############################################################

# for FILE in "$HOME"/lib/services/*.sh
# do
#     source "$FILE"
# done


# source "$HOME/lib/core/registry.sh"
# source "$HOME/lib/core/plugin_manager.sh"

# plugin_load_all



# # #!/bin/bash

# # ###############################################################################
# # # Bootstrap
# # ###############################################################################

# # source "$HOME/lib/core/config.sh"

# # source "$HOME/lib/core/logger.sh"

# # source "$HOME/lib/core/json.sh"

# # source "$HOME/lib/core/utils.sh"

# # init_state

# # init_inventory

# # mkdir -p /var/lib/labctl/scans

# # mkdir -p /var/cache/labctl

# # validate_dependencies

# # ###############################################################
# # # Load Network Engine
# # ###############################################################

# # for FILE in "$LABCTL_HOME"/lib/network/*.sh
# # do
# #     source "$FILE"
# # done

# # ###############################################################
# # # Load UI
# # ###############################################################

# # for FILE in "$LABCTL_HOME"/lib/ui/*.sh
# # do
# #     source "$FILE"
# # done

# # ###############################################################
# # # Load Lab Engine
# # ###############################################################

# # for FILE in "$LABCTL_HOME"/lib/lab/*.sh
# # do
# #     source "$FILE"
# # done

# # ###############################################################
# # # Load Plugins
# # ###############################################################

# # for FILE in "$LABCTL_HOME"/lib/plugins/*.sh
# # do
# #     [[ -f "$FILE" ]] && source "$FILE"
# # done

# # ###############################################################
# # # Dispatcher
# # ###############################################################

# # source "$LABCTL_HOME/lib/core/dispatcher.sh"