function _claude_worktree_entries -d 'Build "<display>\t<fullpath>" lines for every worktree under the given repos'
    # Usage: _claude_worktree_entries <ghq_root> <repo>...
    # Emits one line per directory found under "<repo>/.claude/worktrees/".
    # The display column is "<repo-relative-path>  ▸  <worktree-name>"; the
    # full path follows after a tab so the caller can cd into the selection.
    set -l ghq_root $argv[1]
    set -l repos $argv[2..-1]

    for repo in $repos
        set -l wtdir "$repo/.claude/worktrees"
        test -d "$wtdir"; or continue
        set -l rel (string replace -- "$ghq_root/" "" "$repo")
        for d in $wtdir/*/
            set -l path (string trim --right --chars=/ -- "$d")
            set -l name (path basename -- "$path")
            printf '%s  ▸  %s\t%s\n' "$rel" "$name" "$path"
        end
    end
end
