function _claude_worktree_selector -d 'Resolve the fuzzy selector command from the environment (default: fzf)'
    # Precedence: $CLAUDE_WORKTREE_SELECTOR > legacy $WORKTREE_SELECTOR > fzf.
    set -l selector fzf
    test -n "$WORKTREE_SELECTOR"; and set selector $WORKTREE_SELECTOR
    test -n "$CLAUDE_WORKTREE_SELECTOR"; and set selector $CLAUDE_WORKTREE_SELECTOR
    echo $selector
end
