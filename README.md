# claude-worktree.fish

Fuzzy-search [Claude Code](https://claude.com/claude-code) worktrees across all your [ghq](https://github.com/x-motemen/ghq)-managed repositories and `cd` into the one you pick — the worktree counterpart of [`decors/fish-ghq`](https://github.com/decors/fish-ghq)'s <kbd>Ctrl-G</kbd> repository jump.

Claude Code's `EnterWorktree` creates worktrees under `<repo>/.claude/worktrees/<name>`. This plugin enumerates every such directory beneath your ghq root, lists them in `fzf`, previews each worktree's branch and recent commits, and jumps to the selection. Default key: <kbd>Ctrl-W</kbd>.

## Demo

```
github.com/acme/web-app    ▸  feature-login      │ branch: feature-login
github.com/acme/web-app    ▸  bugfix-123         │
github.com/foo/bar         ▸  feature-x          │ a1b2c3d add login form
                                                 │ e4f5g6h fix validation
> feat                                           │ ...
```

The left pane is the worktree list (searchable by repo name or branch name); the right pane previews the highlighted worktree's current branch and last 15 commits.

## Requirements

- [fish](https://fishshell.com/) 3.6 or later
- [ghq](https://github.com/x-motemen/ghq)
- [fzf](https://github.com/junegunn/fzf)

## Install

With [fisher](https://github.com/jorgebucaran/fisher):

```fish
fisher install nesheep5/claude-worktree.fish
```

## Usage

Press <kbd>Ctrl-W</kbd> on the command line. Whatever you have typed becomes the initial fzf query, so `feat<Ctrl-W>` opens the finder pre-filtered to worktrees matching `feat`.

Select a worktree and press <kbd>Enter</kbd> to `cd` into it.

You can also call the function directly:

```fish
claude-worktree
```

## Key binding and the Ctrl-W default

fish binds <kbd>Ctrl-W</kbd> to `backward-kill-word` by default, and this plugin overrides it. To keep the default and choose your own key, set this before the plugin loads (e.g. at the top of `~/.config/fish/config.fish`):

```fish
set -g claude_worktree_no_bindings 1
```

Then bind the finder wherever you like:

```fish
bind \co claude-worktree   # Ctrl-O, for example
```

## Configuration

- `WORKTREE_SELECTOR` — the fuzzy selector to use (default: `fzf`). Note: the preview and column options are written for `fzf`; other selectors may ignore them.
- `WORKTREE_SELECTOR_OPTS` — extra options passed to the selector.
- `claude_worktree_no_bindings` — set (to any value) to skip the default <kbd>Ctrl-W</kbd> binding.

## How it works

1. `ghq list --full-path` enumerates every repository under the ghq root.
2. For each repo, every directory under `.claude/worktrees/` is collected as a candidate.
3. `fzf` shows `repo ▸ worktree-name`; the full path is carried alongside for the `cd`.
4. The preview pane runs `git -C <path>` to show the branch and recent commits.

## License

MIT
