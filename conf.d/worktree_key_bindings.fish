# Bind Ctrl-W to the worktree fuzzy finder.
#
# NOTE: Ctrl-W is bound to `backward-kill-word` by fish's default key bindings.
# This plugin overrides it. To keep the default behaviour, set the following in
# your config BEFORE this plugin loads (e.g. in ~/.config/fish/config.fish):
#
#     set -g worktree_search_no_bindings 1
#
# ...and bind the finder to a different key yourself, e.g.:
#
#     bind \co __worktree_search   # Ctrl-O
#
if not set -q worktree_search_no_bindings
    bind \cw __worktree_search
    if bind -M insert >/dev/null 2>/dev/null
        bind -M insert \cw __worktree_search
    end
end
