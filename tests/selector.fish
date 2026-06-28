# Tests for _claude_worktree_selector / _claude_worktree_selector_opts:
# environment-variable precedence (CLAUDE_WORKTREE_* over the legacy names).

source (dirname (status filename))/../functions/_claude_worktree_selector.fish
source (dirname (status filename))/../functions/_claude_worktree_selector_opts.fish

# --- selector ---

# Defaults to fzf when nothing is set.
set -e WORKTREE_SELECTOR CLAUDE_WORKTREE_SELECTOR
@test "selector defaults to fzf" (_claude_worktree_selector) = fzf

# Legacy variable is honored as a fallback.
set -e CLAUDE_WORKTREE_SELECTOR
set -lx WORKTREE_SELECTOR legacy-sel
@test "selector falls back to legacy WORKTREE_SELECTOR" (_claude_worktree_selector) = legacy-sel
set -e WORKTREE_SELECTOR

# New variable takes precedence over the legacy one.
set -lx WORKTREE_SELECTOR legacy-sel
set -lx CLAUDE_WORKTREE_SELECTOR new-sel
@test "CLAUDE_WORKTREE_SELECTOR wins over the legacy name" (_claude_worktree_selector) = new-sel
set -e WORKTREE_SELECTOR CLAUDE_WORKTREE_SELECTOR

# --- selector opts ---

# Empty by default (no output lines at all).
set -e WORKTREE_SELECTOR_OPTS CLAUDE_WORKTREE_SELECTOR_OPTS
@test "selector opts empty by default" (_claude_worktree_selector_opts | count) -eq 0

# Legacy opts honored.
set -lx WORKTREE_SELECTOR_OPTS --height=40%
@test "selector opts fall back to legacy name" (_claude_worktree_selector_opts) = --height=40%
set -e WORKTREE_SELECTOR_OPTS

# New opts win.
set -lx WORKTREE_SELECTOR_OPTS --height=40%
set -lx CLAUDE_WORKTREE_SELECTOR_OPTS --height=80%
@test "CLAUDE_WORKTREE_SELECTOR_OPTS wins over the legacy name" (_claude_worktree_selector_opts) = --height=80%
set -e WORKTREE_SELECTOR_OPTS CLAUDE_WORKTREE_SELECTOR_OPTS
