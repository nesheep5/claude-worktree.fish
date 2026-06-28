function __worktree_search -d 'Fuzzy-search Claude Code worktrees across all ghq repos and cd into the selection'
    # Selector (default: fzf). Override with $WORKTREE_SELECTOR / $WORKTREE_SELECTOR_OPTS.
    set -l selector fzf
    set -q WORKTREE_SELECTOR; and test -n "$WORKTREE_SELECTOR"; and set selector $WORKTREE_SELECTOR
    set -l selector_opts
    set -q WORKTREE_SELECTOR_OPTS; and test -n "$WORKTREE_SELECTOR_OPTS"; and set selector_opts $WORKTREE_SELECTOR_OPTS

    if not type -qf $selector
        printf "\n[worktree.fish] ERROR: '%s' not found.\n" $selector
        commandline -f repaint
        return 1
    end

    set -l ghq_root (ghq root 2>/dev/null)
    if test -z "$ghq_root"
        printf "\n[worktree.fish] ERROR: ghq not found or no root configured.\n"
        commandline -f repaint
        return 1
    end

    # Collect "<display>\t<fullpath>" for every directory under any repo's .claude/worktrees/.
    set -l entries
    for repo in (ghq list --full-path)
        set -l wtdir "$repo/.claude/worktrees"
        test -d "$wtdir"; or continue
        set -l rel (string replace -- "$ghq_root/" "" "$repo")
        for d in $wtdir/*/
            set -l path (string trim --right --chars=/ -- "$d")
            set -l name (path basename -- "$path")
            set -a entries (printf '%s  ▸  %s\t%s' "$rel" "$name" "$path")
        end
    end

    if test (count $entries) -eq 0
        printf "\n[worktree.fish] No worktrees found under any '.claude/worktrees/'.\n"
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

    test -n "$select"; and cd "$select"
    commandline -f repaint
end
