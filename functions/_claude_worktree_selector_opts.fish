function _claude_worktree_selector_opts -d 'Resolve extra selector options from the environment'
    # Precedence: $CLAUDE_WORKTREE_SELECTOR_OPTS > legacy $WORKTREE_SELECTOR_OPTS > (none).
    set -l opts
    test -n "$WORKTREE_SELECTOR_OPTS"; and set opts $WORKTREE_SELECTOR_OPTS
    test -n "$CLAUDE_WORKTREE_SELECTOR_OPTS"; and set opts $CLAUDE_WORKTREE_SELECTOR_OPTS
    test -n "$opts"; and echo $opts
end
