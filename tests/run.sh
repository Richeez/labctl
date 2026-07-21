#!/usr/bin/env bash

set -Eeuo pipefail

LABCTL_HOME="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

FAILED=0

echo
echo "========== LABCTL TEST SUITE =========="
echo

for test in "$LABCTL_HOME"/tests/test_*.sh; do

    printf "%-35s" "$(basename "$test")"

    if bash "$test"; then
        echo "PASS"
    else
        echo "FAIL"
        ((FAILED++))
    fi

done

echo

if (( FAILED == 0 )); then
    echo "All tests passed."
else
    echo "$FAILED test(s) failed."
fi

exit "$FAILED"