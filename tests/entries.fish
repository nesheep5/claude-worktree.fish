# Tests for _claude_worktree_entries: it should emit one "<display>\t<path>"
# line per directory under "<repo>/.claude/worktrees/", relative-pathing the
# repo against the ghq root and skipping repos without a worktrees directory.

source (dirname (status filename))/../functions/_claude_worktree_entries.fish

# Build a throwaway ghq-like tree:
#   <root>/github.com/acme/web-app/.claude/worktrees/{feature-login,bugfix-123}
#   <root>/github.com/foo/bar       (no .claude/worktrees → skipped)
set -l root (mktemp -d)
set -l repo_a "$root/github.com/acme/web-app"
set -l repo_b "$root/github.com/foo/bar"
mkdir -p "$repo_a/.claude/worktrees/feature-login"
mkdir -p "$repo_a/.claude/worktrees/bugfix-123"
mkdir -p "$repo_b"

set -l lines (_claude_worktree_entries $root $repo_a $repo_b)

@test "emits one line per worktree directory" (count $lines) -eq 2

# Display column uses the repo path relative to the ghq root.
@test "display is repo-relative and names the worktree" (string match -q '*github.com/acme/web-app  ▸  feature-login*' -- "$lines[1] $lines[2]"; echo $status) -eq 0

# The full path is carried after a tab and points at the real directory.
set -l first_path (string split -f2 \t -- $lines[1])
@test "full path after the tab exists on disk" -d "$first_path"

# A repo without .claude/worktrees contributes nothing.
@test "repo without worktrees dir is skipped" (string match -q '*foo/bar*' -- $lines; echo $status) -eq 1

# No worktrees anywhere → no output.
set -l empty (_claude_worktree_entries $root $repo_b)
@test "no worktrees yields no lines" (count $empty) -eq 0

rm -rf $root
