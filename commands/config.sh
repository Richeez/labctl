#!/usr/bin/env bash

###############################################################################
# LABCTL Configuration Command
###############################################################################

run() {

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

        -h|--help)
            cat <<EOF
Usage: labctl config <action> [arguments]

Actions:
  show | list                 Display configuration values.
  get KEY                     Print a value.
  set KEY VALUE               Set or add a value.
  unset KEY                   Remove a value.
  reset --all                 Restore shipped defaults.
  export FILE | import FILE   Export or import configuration.
  validate | edit             Validate or edit configuration.
EOF
            ;;

        *)

            log_error "Unknown configuration command."

            return "$EXIT_INVALID_ARGUMENT"
            ;;

    esac

}
