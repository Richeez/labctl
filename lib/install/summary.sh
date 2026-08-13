#!/usr/bin/env bash

###############################################################################
# LABCTL Installer Summary
###############################################################################

install_summary() {

    echo

    log_success "LABCTL installation completed."

    echo
    printf "  %-18s %s\n" "Version:" "$VERSION"
    printf "  %-18s %s\n" "Application:" "$INSTALL_DIR"
    printf "  %-18s %s\n" "Configuration:" "$CONFIG_FILE"
    printf "  %-18s %s\n" "Cache:" "$CACHE_DIR"
    printf "  %-18s %s\n" "State:" "$STATE_DIR"
    printf "  %-18s %s\n" "Logs:" "$LOG_DIR"
    printf "  %-18s %s\n" "Launcher:" "$BIN_LINK"

    echo
    log_info "Run 'labctl version' to verify the installation."

}


update_summary() {

    echo

    log_success "LABCTL update completed."

    echo
    printf "  %-18s %s\n" "Version:" "$VERSION"
    printf "  %-18s %s\n" "Application:" "$INSTALL_DIR"

    echo

}


uninstall_summary() {

    echo

    log_success "LABCTL uninstallation completed."

    echo
    log_info "The LABCTL application and launcher have been removed."

    echo

}