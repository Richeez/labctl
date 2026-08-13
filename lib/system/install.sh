#!/usr/bin/env bash

###############################################################################
# Installer
###############################################################################

system_install() {

    ui_start "Checking dependencies"

    dependencies_check

    ui_finish

    ################################################

    ui_start "Creating directories"

    directories_create

    ui_finish

    ################################################

    ui_start "Installing application"

    file_copy \
        "$LABCTL_HOME" \
        "$INSTALL_DIR"

    ui_finish

    ################################################

    ui_start "Installing launcher"

    file_symlink \
        "$INSTALL_DIR/bin/labctl" \
        "$BIN_LINK"

    ui_finish

    ################################################

    ui_start "Creating configuration"

    settings_create

    ui_finish

    ################################################

    ui_start "Applying permissions"

    permissions_fix

    ui_finish

}

install_run() {

    ui_start "LABCTL INSTALLER"

    trap transaction_abort ERR

    ui_step "Acquiring lock" lock_acquire

    ui_step "Checking permissions" install_assert_root

    ui_step "Checking dependencies" dependency_check

    ui_step "Checking existing installation" install_assert_not_installed

    ui_step "Starting transaction" transaction_begin

    ui_step "Creating backup" backup_create

    ui_step "Creating directories" install_directories

    ui_step "Installing application" install_files

    ui_step "Installing launcher" launcher_install

    ui_step "Installing completions" install_completion

    ui_step "Installing configuration" config_install

    ui_step "Setting permissions" permission_install

    ui_step "Creating cache" cache_install

    ui_step "Creating runtime state" state_install

    ui_step "Creating manifest" manifest_create

    ui_step "Writing version" version_write

    ui_step "Verifying installation" verify_installation

    ui_step "Finalizing transaction" transaction_commit

    lock_release

    trap - ERR

    install_summary

    ui_finish

}