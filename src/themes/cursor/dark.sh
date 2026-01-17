#!/usr/bin/env bash
# =============================================================================
# Theme: Cursor
# Variant: Dark
# Description: Cursor IDE Dark theme for tmux-powerkit
# https://github.com/gantoreno/nvim-cursor
# =============================================================================

declare -gA THEME_COLORS=(
    # Status Bar
    [statusbar-bg]="#141414"      # Main background
    [statusbar-fg]="#e4e4e4"      # Main foreground

    # Session Indicator
    [session-bg]="#a8cc7c"        # Normal session bg (teal)
    [session-fg]="#141414"        # Session text
    [session-prefix-bg]="#efb080" # Prefix mode (yellow)
    [session-copy-bg]="#505050"   # Copy mode (cyan)

    # Windows
    [window-active-base]="#aaa0fa"   # Active window (teal)
    [window-inactive-base]="#505050" # Inactive windows

    # Pane Borders
    [pane-border-active]="#82d2ce"   # Active pane (teal)
    [pane-border-inactive]="#505050" # Inactive panes

    # Health States
    [ok-base]="#505050"           # Normal state (neutral)
    [good-base]="#a8cc7c"         # Success (green)
    [info-base]="#82d2ce"         # Info (teal)
    [warning-base]="#efb080"      # Warning (yellow)
    [error-base]="#82d2ce"        # Error (red)
    [disabled-base]="#6e6e6e"     # Disabled (gray)

    # Messages
    [message-bg]="#141414"        # Message background
    [message-fg]="#e4e4e4"        # Message text
)
