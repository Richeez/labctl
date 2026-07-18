
# ###############################################################
# # Events
# ###############################################################

# for FILE in "$LABCTL_HOME"/lib/core/events.sh
# do
#     source "$FILE"
# done

# ###############################################################
# # Providers
# ###############################################################

# for FILE in "$LABCTL_HOME"/lib/providers/*.sh
# do
#     source "$FILE"
# done



# ###############################################################
# # Services
# ###############################################################

# for FILE in "$LABCTL_HOME"/lib/services/*.sh
# do
#     source "$FILE"
# done


# source "$LABCTL_HOME/lib/core/registry.sh"
# source "$LABCTL_HOME/lib/core/plugin_manager.sh"

# plugin_load_all



# # #!/bin/bash

# # ###############################################################################
# # # Bootstrap
# # ###############################################################################

# # source "$LABCTL_HOME/lib/core/config.sh"

# # source "$LABCTL_HOME/lib/core/logger.sh"

# # source "$LABCTL_HOME/lib/core/json.sh"

# # source "$LABCTL_HOME/lib/core/utils.sh"

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