# Bind Ctrl-W to the worktree fuzzy finder.
#
# NOTE: Ctrl-W is bound to `backward-kill-path-component` by fish's default key bindings.
# This plugin overrides it. To keep the default behaviour, set the following in
# your config BEFORE this plugin loads (e.g. in ~/.config/fish/config.fish):
#
#     set -g claude_worktree_no_bindings 1
#
# ...and bind the finder to a different key yourself, e.g.:
#
#     bind \co claude-worktree   # Ctrl-O
#
if not set -q claude_worktree_no_bindings
    bind \cw claude-worktree
    if bind -M insert >/dev/null 2>/dev/null
        bind -M insert \cw claude-worktree
    end
end

# Remove the Ctrl-W binding when fisher uninstalls the plugin.
# fisher emits "<conf.d file basename>_uninstall", i.e. "claude-worktree_uninstall".
#
# Only the user-level binding this plugin added is erased, which lets fish's
# preset binding (backward-kill-path-component) take effect again. A Ctrl-W
# binding the user set themselves — including any set while opted out via
# claude_worktree_no_bindings — is left untouched.
function _claude_worktree_uninstall --on-event claude-worktree_uninstall
    set -q claude_worktree_no_bindings; and return
    for mode in default insert
        if string match -q -- '* claude-worktree' (bind --user -M $mode \cw 2>/dev/null)
            bind --user -M $mode -e \cw
        end
    end
end
