function claude-worktree -d 'Fuzzy-search Claude Code worktrees across all ghq repos and cd into the selection'
    # Selector (default: fzf). Override with $CLAUDE_WORKTREE_SELECTOR / $CLAUDE_WORKTREE_SELECTOR_OPTS.
    # The legacy $WORKTREE_SELECTOR / $WORKTREE_SELECTOR_OPTS names are still honored as a fallback.
    set -l selector (_claude_worktree_selector)
    set -l selector_opts (_claude_worktree_selector_opts)

    if not type -qf $selector
        printf "\n[claude-worktree.fish] ERROR: '%s' not found.\n" $selector
        commandline -f repaint
        return 1
    end

    set -l ghq_root (ghq root 2>/dev/null)
    if test -z "$ghq_root"
        printf "\n[claude-worktree.fish] ERROR: ghq not found or no root configured.\n"
        commandline -f repaint
        return 1
    end

    # Collect "<display>\t<fullpath>" for every directory under any repo's .claude/worktrees/.
    set -l entries (_claude_worktree_entries $ghq_root (ghq list --full-path))

    if test (count $entries) -eq 0
        printf "\n[claude-worktree.fish] No worktrees found under any '.claude/worktrees/'.\n"
        commandline -f repaint
        return 0
    end

    # Use the current command line as the initial query (mirrors decors/fish-ghq).
    set -l query (commandline -b)
    set -l flags
    test -n "$query"; and set flags --query="$query"

    # Preview: current branch + recent commits of the highlighted worktree.
    # Written in POSIX sh so it works regardless of fzf's preview shell.
    set -l preview 'git -C {2} rev-parse --abbrev-ref HEAD 2>/dev/null | sed "s/^/branch: /"; echo; git -C {2} log --oneline --decorate -15 --color=always 2>/dev/null'

    set -l select (printf '%s\n' $entries | \
        $selector $selector_opts $flags \
            --ansi --delimiter \t --with-nth 1 \
            --preview $preview --preview-window 'right,55%' | \
        string split -f2 \t)

    if test -n "$select"
        if test -d "$select"
            cd "$select"
        else
            printf "\n[claude-worktree.fish] ERROR: directory no longer exists: %s\n" "$select"
            commandline -f repaint
            return 1
        end
    end
    commandline -f repaint
end
