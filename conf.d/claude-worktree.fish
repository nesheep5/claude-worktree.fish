# Bind Ctrl-W to the worktree fuzzy finder.
#
# NOTE: Ctrl-W is bound to `backward-kill-word` by fish's default key bindings.
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
function _claude_worktree_uninstall --on-event claude_worktree_uninstall
    bind -e \cw 2>/dev/null
    bind -M insert -e \cw 2>/dev/null
end
