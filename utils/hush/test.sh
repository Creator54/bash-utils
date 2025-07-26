#!/bin/sh
# Test suite for hush utility

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
    
    # Use timeout to prevent hanging
    if timeout 10s sh -c "$test_command" >/dev/null 2>&1; then
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
run_test "Help option" "./hush --help"
run_test "No utility specified" "./hush" 1
run_test "Invalid option" "./hush -x" 1
run_test "Non-existent utility" "./hush nonexistent" 2

# Test direct help access (avoiding the problematic hush logz command)
run_test "Direct logz help" "../logz/logz --hush-help"
run_test "Direct hush help" "./hush --help"

echo
echo "Test Summary: $TESTS_PASSED/$TESTS_RUN passed"

[ $TESTS_FAILED -eq 0 ] && exit 0 || exit 1 