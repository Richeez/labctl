#!/usr/bin/env bash

run() {

    local ACTION="${1:-}"

    case "$ACTION" in

        create)

            shift

            snapshot_create "$@"

            ;;


        list)

            shift

            snapshot_list "$@"

            ;;


        show)

            shift

            snapshot_show "$@"

            ;;


        delete)

            shift

            snapshot_delete "$@"

            ;;


        clear)

            shift

            snapshot_clear "$@"

            ;;


        restore)

            shift

            snapshot_restore "$@"

            ;;


        -h|--help|help)

            cat <<EOF
Usage:
  labctl snapshot <command>

Commands:
  create              Create a new system snapshot.
  list                List available snapshots.
  show <id>            Show snapshot information.
  delete <id>          Delete a snapshot.
  clear                Delete all snapshots.
  restore <id>         Restore a snapshot.

Options:
  -h, --help            Show this help.

EOF

            return "$EXIT_SUCCESS"

            ;;


        *)

            log_error "Unknown snapshot command: ${ACTION:-none}"

            echo

            cat <<EOF
Usage:
  labctl snapshot <command>

Commands:
  create
  list
  show <id>
  delete <id>
  clear
  restore <id>

EOF

            return "$EXIT_INVALID_ARGUMENT"

            ;;

    esac
}