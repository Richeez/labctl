# #!/usr/bin/env bash
# #
# # constants.sh
# # Global constants used throughout LABCTL.
# #

# #######################################
# # Project Information
# #######################################

# readonly LABCTL_NAME="LABCTL"
# readonly LABCTL_VERSION="2.0.0-alpha"

# #######################################
# # Project Root
# #######################################

# readonly LABCTL_HOME="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# #######################################
# # User Directories
# #######################################

# readonly CONFIG_DIR="${HOME}/.config/labctl"
# readonly LOG_DIR="${CONFIG_DIR}/logs"
# readonly PROFILE_DIR="${CONFIG_DIR}/profiles"
# readonly PLUGIN_DIR="${CONFIG_DIR}/plugins"

# #######################################
# # Configuration Files
# #######################################

# readonly CONFIG_FILE="${CONFIG_DIR}/config.yaml"
# readonly LOG_FILE="${LOG_DIR}/labctl.log"

# #######################################
# # Internal Directories
# #######################################

# readonly LIB_DIR="${LABCTL_HOME}/lib"
# readonly COMMAND_DIR="${LABCTL_HOME}/commands"
# readonly TEST_DIR="${LABCTL_HOME}/tests"

# #######################################
# # Default Settings
# #######################################

# readonly DEFAULT_PROFILE="update"
# readonly DEFAULT_LOG_LEVEL="INFO"

# #######################################
# # Supported Profiles
# #######################################

# readonly SUPPORTED_PROFILES=(
#     update
#     contain
#     lab
#     bridged
# )

# #######################################
# # Required System Commands
# #######################################

# readonly REQUIRED_COMMANDS=(
#     nmcli
#     ip
#     awk
#     grep
#     sed
# )

# #######################################
# # Exit Codes
# #######################################

# readonly EXIT_SUCCESS=0
# readonly EXIT_FAILURE=1
# readonly EXIT_INVALID_ARGUMENT=2
# readonly EXIT_PERMISSION_DENIED=3
# readonly EXIT_CONFIGURATION_ERROR=4
# readonly EXIT_NETWORK_ERROR=5
# readonly EXIT_DEPENDENCY_MISSING=6
# readonly EXIT_UNKNOWN_ERROR=99