#!/usr/bin/env bash

###############################################################################
# LABCTL Install Command
###############################################################################

run() {

    local FORCE=false

    while (($#)); do
        case "$1" in
            --force)
                FORCE=true
                ;;
            -h|--help)
                cat <<EOF
Usage: labctl install [--force]

Install LABCTL system-wide.

Options:
  --force       Replace an existing installation. The current configuration is preserved.
  -h, --help    Show this help.

This command requires root privileges. Run it from a LABCTL source checkout:
  sudo ./install.sh
EOF
                return "$EXIT_SUCCESS"
                ;;
            *)
                log_error "Unknown install option: $1"
                return "$EXIT_INVALID_ARGUMENT"
                ;;
        esac
        shift
    done

    install_assert_root || return $?

    if [[ -d "$INSTALL_DIR" && "$FORCE" != true ]]; then
        log_error "LABCTL is already installed at $INSTALL_DIR."
        log_info "Use 'labctl update' to refresh it, or 'labctl install --force' to replace it."
        return "$EXIT_FAILURE"
    fi


    ###########################################################################
    # Transaction
    ###########################################################################

    transaction_begin || return "$EXIT_FAILURE"

    if [[ "$FORCE" == true ]] && ! backup_create; then
        log_error "Unable to create an installation backup."
        transaction_abort || true
        return "$EXIT_FAILURE"
    fi


    ###########################################################################
    # Installation workflow
    ###########################################################################

    if workflow_begin INSTALL_WORKFLOW; then

        transaction_commit || {
            log_error "Failed to commit installation."
            return "$EXIT_FAILURE"
        }

        install_summary

        return "$EXIT_SUCCESS"

    fi


    ###########################################################################
    # Failure
    ###########################################################################

    transaction_abort || true

    return "$EXIT_FAILURE"

}
