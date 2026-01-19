#!/usr/bin/env bash
# =============================================================================
# PowerKit Test: Theme Loader Unit Tests
# Description: Tests theme loading functionality including cache control
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
POWERKIT_ROOT="${POWERKIT_ROOT:-$(cd "$SCRIPT_DIR/.." && pwd)}"
export POWERKIT_ROOT

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo "=== Theme Loader Unit Tests ==="
echo ""

TESTS_PASSED=0
TESTS_FAILED=0

# Helper to run a test
run_test() {
    local test_name="$1"
    local test_func="$2"

    if $test_func; then
        echo -e "${GREEN}✓${NC} $test_name"
        ((TESTS_PASSED++)) || true
    else
        echo -e "${RED}✗${NC} $test_name"
        ((TESTS_FAILED++)) || true
    fi
}

# =============================================================================
# Test: POWERKIT_DEFAULT_THEME_CACHE_ENABLED exists
# =============================================================================
test_default_cache_enabled_exists() {
    # Source defaults
    # shellcheck disable=SC1091
    . "$POWERKIT_ROOT/src/core/defaults.sh"

    [[ -n "${POWERKIT_DEFAULT_THEME_CACHE_ENABLED:-}" ]]
}

# =============================================================================
# Test: Default value is "true"
# =============================================================================
test_default_cache_enabled_is_true() {
    # shellcheck disable=SC1091
    . "$POWERKIT_ROOT/src/core/defaults.sh"

    [[ "${POWERKIT_DEFAULT_THEME_CACHE_ENABLED}" == "true" ]]
}

# =============================================================================
# Test: load_theme function exists
# =============================================================================
test_load_theme_exists() {
    # shellcheck disable=SC1091
    . "$POWERKIT_ROOT/src/core/bootstrap.sh"

    declare -F load_theme &>/dev/null
}

# =============================================================================
# Test: load_theme respects cache disabled option
# =============================================================================
test_load_theme_cache_disabled() {
    # Create a mock tmux that returns "false" for theme cache enabled
    local mock_tmux
    mock_tmux=$(mktemp)
    cat > "$mock_tmux" << 'EOF'
#!/usr/bin/env bash
# Mock tmux for testing
case "$*" in
    *"@powerkit_theme_cache_enabled"*)
        echo "false"
        ;;
    *"@powerkit_theme"*)
        echo ""
        ;;
    *"@powerkit_theme_variant"*)
        echo ""
        ;;
    *)
        # Pass through to real tmux for other options
        command tmux "$@" 2>/dev/null || echo ""
        ;;
esac
EOF
    chmod +x "$mock_tmux"

    # Source bootstrap
    # shellcheck disable=SC1091
    . "$POWERKIT_ROOT/src/core/bootstrap.sh"

    # Override tmux command
    tmux() { "$mock_tmux" "$@"; }
    export -f tmux

    # Clear any cached theme
    THEME_COLORS=()
    _COLOR_VARIANTS=()
    _CURRENT_THEME=""
    _CURRENT_VARIANT=""

    # Load theme - should work without using cache
    load_theme "catppuccin" "mocha" 2>/dev/null
    local result=$?

    # Cleanup
    rm -f "$mock_tmux"

    # Should succeed even with cache disabled
    [[ $result -eq 0 && ${#THEME_COLORS[@]} -gt 0 ]]
}

# =============================================================================
# Run Tests
# =============================================================================

echo "--- Default Option Tests ---"
run_test "POWERKIT_DEFAULT_THEME_CACHE_ENABLED exists" test_default_cache_enabled_exists
run_test "Default cache enabled value is 'true'" test_default_cache_enabled_is_true

echo ""
echo "--- Function Tests ---"
run_test "load_theme function exists" test_load_theme_exists
run_test "load_theme works with cache disabled" test_load_theme_cache_disabled

echo ""
echo "=== Results ==="
echo -e "Passed: ${GREEN}${TESTS_PASSED}${NC}"
echo -e "Failed: ${RED}${TESTS_FAILED}${NC}"

if [[ $TESTS_FAILED -gt 0 ]]; then
    echo -e "${RED}Theme loader tests FAILED${NC}"
    exit 1
fi

echo -e "${GREEN}Theme loader tests PASSED${NC}"
exit 0
