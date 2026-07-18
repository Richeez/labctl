#!/bin/bash

set -e

echo

echo "======================================"

echo "Running LABCTL Test Suite"

echo "======================================"

echo

bats tests/unit

echo

bats tests/integration

echo

echo "All tests passed."