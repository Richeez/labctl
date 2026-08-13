#!/usr/bin/env bash

###############################################################################
# LABCTL Constants
###############################################################################

: "${LABCTL_HOME:?LABCTL_HOME is not set}"

readonly NAME="LABCTL"
readonly VERSION="2.0.0"
readonly PROJECT_ROOT="$LABCTL_HOME"

###############################################################################
# Installation
###############################################################################

readonly INSTALL_DIR="/opt/labctl"

readonly BIN_DIR="/usr/local/bin"

readonly BIN_LINK="$BIN_DIR/labctl"

###############################################################################
# XDG Directories
###############################################################################

readonly XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

readonly XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

readonly XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

readonly XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"


######################################################################################
# Logging
######################################################################################

readonly LOG_DATE_FORMAT="+%Y-%m-%d %H:%M:%S"


###############################################################################
# Directories
###############################################################################

readonly CONFIG_DIR="$XDG_CONFIG_HOME/labctl"

readonly CONFIG_FILE="$CONFIG_DIR/config.conf"

readonly CACHE_DIR="$XDG_CACHE_HOME/labctl"

readonly STATE_DIR="$XDG_STATE_HOME/labctl"

readonly BASH_COMPLETION_DIR="/etc/bash_completion.d"

readonly ZSH_COMPLETION_DIR="/usr/share/zsh/site-functions"

readonly BACKUP_ROOT="$STATE_DIR/backups"

readonly LOG_DIR="$XDG_DATA_HOME/labctl/logs"

readonly LOG_FILE="$LOG_DIR/labctl.log"

readonly MANIFEST="$STATE_DIR/install.manifest"

readonly INSTALL_IGNORE="$PROJECT_ROOT/.installignore"

readonly METADATA="$STATE_DIR/install.json"

###############################################################################
# Internal Directories
###############################################################################

readonly LIB_DIR="$LABCTL_HOME/lib"

readonly COMMAND_DIR="$LABCTL_HOME/commands"

readonly TEST_DIR="$LABCTL_HOME/tests"

readonly CONFIG_TEMPLATE="$LABCTL_HOME/config/default.conf"

###############################################################################
# Profiles
###############################################################################

readonly PROFILE_NAT="NAT"

readonly PROFILE_NATNET="NATNET"

readonly PROFILE_LAB="LAB"

readonly PROFILE_BRIDGED="BRIDGED"

readonly DEFAULT_PROFILE_BUILTIN="$PROFILE_NAT"

###############################################################################
# Exit Codes
###############################################################################

readonly EXIT_SUCCESS=0
readonly EXIT_FAILURE=1
readonly EXIT_INVALID_ARGUMENT=2
readonly EXIT_PERMISSION_DENIED=3
readonly EXIT_CONFIGURATION_ERROR=4
readonly EXIT_NETWORK_ERROR=5
readonly EXIT_DEPENDENCY_MISSING=6
readonly EXIT_UNKNOWN_ERROR=99

###############################################################################
# Backup / Transactions
###############################################################################

readonly TRANSACTION_DIR="$STATE_DIR/transactions"

###############################################################################
# Boolean
###############################################################################

readonly TRUE=0

readonly FALSE=1

readonly INSTALL_EXCLUDES=(
    ".git"
    ".github"
    ".vscode"
    ".idea"
    "tests"
    "test"
    "tmp"
    "temp"
    ".cache"
    "cache"
    "logs"
    "node_modules"
    "__pycache__"
)

readonly REQUIRED_COMMANDS=(
    bash
    nmcli
    ip
    awk
    grep
    sed
    systemctl
    ping
    curl
)

readonly INSTALL_WORKFLOW=(

    "Checking dependencies:dependencies_check"

    "Creating directories:directories_create"

    "Installing application:install_application"

    "Installing launcher:install_launcher"

    "Installing completions:completion_install"

    "Creating configuration:settings_create"

    "Applying permissions:permissions_fix"

    "Verifying installation:system_verify"

)

readonly DOCTOR_WORKFLOW=(

    "Validating profiles:profile_validate_all"

    "Checking NetworkManager:verify_networkmanager"

    "Checking interfaces:verify_interfaces"

    "Checking routes:verify_default_route"

    "Checking gateway:verify_gateway"

    "Checking DNS:verify_dns"

    "Checking Internet:verify_internet"

)

readonly UPDATE_WORKFLOW=(

    "Checking dependencies:dependencies_check"

    "Creating backup:backup_create"

    "Updating application:update_application"

    "Updating launcher:install_launcher"

    "Updating completions:completion_install"

    "Migrating configuration:settings_migrate"

    "Applying permissions:permissions_fix"

    "Refreshing cache:cache_rebuild"

    "Refreshing state:refresh_state"

    "Verifying installation:system_verify"

)

readonly UNINSTALL_WORKFLOW=(

    "Removing application:remove_application"

    "Removing launcher:launcher_remove"

    # "Removing cache:cleanup_cache"

    # "Removing state:state_remove"

    "Verifying application removal:verify_application_removed"

    "Verifying launcher removal:verify_launcher_removed"




)

readonly REPAIR_WORKFLOW=(

    "Repairing NAT:repair_nat"

    "Repairing LAB:repair_lab"

    "Repairing BRIDGED:repair_bridged"

    "Repairing NATNET:repair_natnet"

)