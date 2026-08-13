#!/usr/bin/env bash

###############################################################################
# LABCTL Configuration Command
###############################################################################

run() {

    settings_init

    local ACTION="${1:-show}"

    shift || true

    case "$ACTION" in

        show)
            config_show
            ;;

        list)
            config_list
            ;;

        get)
            config_get "$@"
            ;;

        set)
            config_set "$@"
            ;;

        unset)
            config_unset "$@"
            ;;

        reset)
            config_reset "$@"
            ;;

        export)
            config_export "$@"
            ;;

        import)
            config_import "$@"
            ;;

        validate)
            config_validate
            ;;

        edit)
            config_edit
            ;;

        *)

            log_error "Unknown configuration command."

            return 1
            ;;

    esac

}