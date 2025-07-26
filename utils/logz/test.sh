#!/bin/sh
# Test suite for logz utility

set -e

TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

run_test() {
    local test_name="$1"
    local test_command="$2"
    local expected_exit="$3"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    echo "Running test: $test_name"
    
    if eval "$test_command" >/dev/null 2>&1; then
        local exit_code=$?
        if [ "$exit_code" -eq "${expected_exit:-0}" ]; then
            echo "  ✓ PASS"
            TESTS_PASSED=$((TESTS_PASSED + 1))
        else
            echo "  ✗ FAIL (exit code $exit_code, expected ${expected_exit:-0})"
            TESTS_FAILED=$((TESTS_FAILED + 1))
        fi
    else
        local exit_code=$?
        if [ "$exit_code" -eq "${expected_exit:-0}" ]; then
            echo "  ✓ PASS"
            TESTS_PASSED=$((TESTS_PASSED + 1))
        else
            echo "  ✗ FAIL (exit code $exit_code, expected ${expected_exit:-0})"
            TESTS_FAILED=$((TESTS_FAILED + 1))
        fi
    fi
}

# Basic functionality
run_test "Help option" "./logz -h"
run_test "No message provided" "./logz" 1
run_test "Invalid option" "./logz -x" 1
run_test "Invalid log level" "./logz -l INVALID 'test message'" 2
run_test "Invalid format" "./logz -f invalid 'test message'" 1

# Valid usage tests
run_test "Basic message" "./logz 'test message'"
run_test "Debug level" "./logz -l DEBUG 'debug message'"
run_test "Error level" "./logz -l ERROR 'error message'"
run_test "JSON format" "./logz -f json 'json message'"
run_test "Color output" "./logz -c 'colored message'"
run_test "No timestamp" "./logz -T 'no timestamp message'"

# File output test
TEMP_LOG=$(mktemp)
run_test "File output" "./logz -o $TEMP_LOG 'file message'"
[ -f "$TEMP_LOG" ] && rm "$TEMP_LOG"

echo
echo "Test Summary: $TESTS_PASSED/$TESTS_RUN passed"

[ $TESTS_FAILED -eq 0 ] && exit 0 || exit 1 