# Tests for the fisher uninstall handler in conf.d/claude-worktree.fish:
# on "fisher remove" it should drop the Ctrl-W binding the plugin added (so
# fish's preset backward-kill-path-component applies again), and leave alone
# any Ctrl-W binding the user set themselves.
#
# fisher 4.x emits "<conf.d file basename>_uninstall", i.e.
# "claude-worktree_uninstall" (hyphen), so that is the event emitted here.

set -l conf (dirname (status filename))/../conf.d/claude-worktree.fish

# The user-level Ctrl-W binding in the given mode ("" when there is none).
function _user_cw --argument-names mode
    bind --user -M $mode \cw 2>/dev/null | string match -r '\S+$'
end

# The Ctrl-W binding fish actually uses in the given mode (user over preset).
function _effective_cw --argument-names mode
    set -l cmds (bind -M $mode \cw 2>/dev/null | string match -r '\S+$')
    echo $cmds[-1]
end

# Start every case from fish's own defaults: no user-level Ctrl-W binding, and
# the preset bindings fish ships for the default and insert modes. Passing -M
# keeps fish_default_key_bindings from touching $fish_key_bindings.
function _reset_bindings
    bind --user -M default -e \cw 2>/dev/null
    bind --user -M insert -e \cw 2>/dev/null
    fish_default_key_bindings -M default
    fish_default_key_bindings -M insert
end

# --- the plugin's own binding is removed ---

_reset_bindings
set -e claude_worktree_no_bindings
source $conf

@test "plugin binds Ctrl-W in default mode" (_user_cw default) = claude-worktree
@test "plugin binds Ctrl-W in insert mode" (_user_cw insert) = claude-worktree

emit claude-worktree_uninstall

@test "uninstall removes the default-mode binding" -z (_user_cw default)
@test "uninstall removes the insert-mode binding" -z (_user_cw insert)
@test "default mode falls back to fish's preset" (_effective_cw default) = backward-kill-path-component
@test "insert mode falls back to fish's preset" (_effective_cw insert) = backward-kill-path-component

# --- a user's own rebinding after the plugin loaded is kept ---

_reset_bindings
set -e claude_worktree_no_bindings
source $conf
bind \cw kill-whole-line

emit claude-worktree_uninstall

@test "uninstall keeps a user's own Ctrl-W binding" (_user_cw default) = kill-whole-line
@test "uninstall still removes the plugin's insert-mode binding" -z (_user_cw insert)

# --- opt-out: the plugin bound nothing, so it erases nothing ---

_reset_bindings
set -g claude_worktree_no_bindings 1
source $conf

@test "opt-out leaves Ctrl-W unbound by the plugin" -z (_user_cw default)

# The user may bind the finder to Ctrl-W themselves; that binding is theirs.
bind \cw claude-worktree

emit claude-worktree_uninstall

@test "opt-out: uninstall keeps the user's own binding" (_user_cw default) = claude-worktree

_reset_bindings
set -e claude_worktree_no_bindings
functions -e _user_cw _effective_cw _reset_bindings
