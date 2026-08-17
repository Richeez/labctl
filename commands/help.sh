#!/bin/bash

###############################################################################
# HELP
###############################################################################

run() {

cat <<EOF

LABCTL v$VERSION

Usage: labctl <command> [options]

Network modes (root required):
  network internet|nat      Enable Internet access through NAT.
  network contain           Switch to NAT Network containment mode.
  network lab               Switch to the host-only laboratory.
  network bridged           Connect to the physical LAN (confirmation required).

Operational commands:
  status                    Show current network status.
  doctor [--repair]         Check network health and optionally repair profiles.
  config <action>           View or manage configuration.
  cache <action>            Inspect or rebuild cached state.

Installation commands (root required):
  install [--force]         Install LABCTL from this source checkout.
  update [--backup]         Refresh the installed checkout with a rollback backup.
  uninstall [--purge]       Remove LABCTL; --purge also removes user data.

Other commands:
  version                   Show version information.
  test                      Run the test suite.
  help                      Display this help message.

Legacy aliases: net, contain, lab, bridged, upgrade.

EOF

}
