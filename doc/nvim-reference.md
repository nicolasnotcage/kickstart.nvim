# Neovim Kickstart Quick Reference

Leader key: `Space`

**Tip:** Press `Space` by itself and wait — which-key will show all available leader bindings. Press any prefix (like `gr`) and wait to see what follows.

---

## Window & Split Management

*Moving between panes, creating splits, resizing.*

| Key | Action |
|-----|--------|
| `C-h` | Move focus to left window |
| `C-l` | Move focus to right window |
| `C-j` | Move focus to lower window |
| `C-k` | Move focus to upper window |
| `:vs` | Vertical split (side by side) |
| `:sp` | Horizontal split (stacked) |
| `C-w =` | Equalize split sizes |
| `C-w >` / `C-w <` | Increase/decrease width |
| `C-w +` / `C-w -` | Increase/decrease height |
| `:q` | Close current window |
| `:only` | Close all windows except current |

---

## File Browser (Neo-tree)

*Browsing, creating, and managing files in the project tree.*

| Key | Action |
|-----|--------|
| `\` | Toggle file browser open/closed |
| `Enter` | Open file / expand directory |
| `a` | Create new file (end with `/` for directory) |
| `d` | Delete file or directory |
| `r` | Rename file or directory |
| `c` | Copy file |
| `m` | Move file |
| `q` | Close Neo-tree window |
| `.` | Toggle hidden (dot) files |
| `?` | Show Neo-tree help / keybindings |

Use `C-h` to jump back to the editor from Neo-tree.

---

## Finding Things (Telescope)

*Fuzzy finding files, text, symbols, and more across the project.*

| Key | Action |
|-----|--------|
| `Space sf` | Search files by name |
| `Space sg` | Search by grep (live text search across project) |
| `Space sw` | Search for word under cursor |
| `Space s.` | Search recent files |
| `Space Space` | Find open buffers |
| `Space /` | Fuzzy search in current buffer |
| `Space s/` | Live grep in open files only |
| `Space sd` | Search all diagnostics |
| `Space sk` | Search keymaps (great for discovering bindings) |
| `Space sh` | Search help tags |
| `Space sc` | Search commands |
| `Space sn` | Search Neovim config files |
| `Space ss` | Search Telescope pickers (meta-search) |
| `Space sr` | Resume last Telescope search |

**Inside a Telescope window:**

| Key | Action |
|-----|--------|
| `C-n` / `C-p` | Next / previous result |
| `Enter` | Open selected |
| `C-/` (insert) or `?` (normal) | Show Telescope keybindings |
| `Esc` | Close Telescope |

---

## Buffers

*Switching between open files.*

| Key | Action |
|-----|--------|
| `Space Space` | List open buffers (Telescope) |
| `:bn` | Next buffer |
| `:bp` | Previous buffer |
| `:bd` | Close current buffer |
| `:e filename` | Open a file by path |

---

## Code Navigation (LSP)

*Jumping to definitions, finding references, exploring symbols. These activate when clangd attaches to a C/C++ buffer.*

| Key | Action |
|-----|--------|
| `grd` | Go to definition |
| `grD` | Go to declaration (e.g., header file in C/C++) |
| `grr` | Find all references |
| `gri` | Go to implementation |
| `grt` | Go to type definition |
| `gO` | List document symbols (functions, types, etc.) |
| `gW` | Search workspace symbols (across entire project) |
| `C-t` | Jump back after any go-to action |
| `K` | Hover documentation (built-in, shows type info) |

---

## Code Editing (LSP)

*Renaming, code actions, formatting.*

| Key | Action |
|-----|--------|
| `grn` | Rename symbol (across all files) |
| `gra` | Code action (quick fixes, refactors) |
| `Space f` | Format buffer (uses conform, falls back to LSP) |

**Note:** Format-on-save is disabled for C/C++ by default in your config. Use `Space f` to format manually.

---

## Autocomplete (Blink.cmp)

*Accepting completions, navigating the menu, reading docs.*

| Key | Action |
|-----|--------|
| (just type) | Completion menu appears automatically |
| `C-n` | Select next item |
| `C-p` | Select previous item |
| `C-y` | Accept selected completion |
| `C-e` | Dismiss completion menu |
| `C-space` | Manually trigger completion / show docs |
| `C-k` | Toggle signature help |
| `Tab` / `S-Tab` | Jump to next/previous snippet placeholder |

---

## Diagnostics & Errors

*Reading and navigating compiler errors and warnings.*

| Key | Action |
|-----|--------|
| `[d` | Jump to previous diagnostic |
| `]d` | Jump to next diagnostic |
| `Space q` | Open diagnostic quickfix list |
| `Space sd` | Search all diagnostics (Telescope) |

Diagnostics show inline at end of line by default. When you jump with `[d`/`]d`, a floating window auto-opens with the full error text.

---

## Text Objects & Surround (mini.nvim)

*Selecting, changing, and wrapping text efficiently.*

**Around / Inside (mini.ai):**

| Key | Action |
|-----|--------|
| `va)` | Visually select around parentheses |
| `vi)` | Visually select inside parentheses |
| `ci"` | Change inside double quotes |
| `da]` | Delete around square brackets |
| `yinq` | Yank inside next quote |

Works with: `(`, `)`, `{`, `}`, `[`, `]`, `"`, `'`, `` ` ``, `<`, `>`

**Surround (mini.surround):**

| Key | Action |
|-----|--------|
| `saiw)` | Surround add inner word with parens |
| `sd'` | Surround delete quotes |
| `sr)"` | Surround replace parens with double quotes |

---

## Git (Gitsigns)

*Navigating hunks, staging changes, viewing blame. Active in any git-tracked file.*

**Navigation:**

| Key | Action |
|-----|--------|
| `]c` | Jump to next changed hunk |
| `[c` | Jump to previous changed hunk |

**Actions (leader = Space, h = hunk):**

| Key | Action |
|-----|--------|
| `Space hs` | Stage hunk (works in visual mode too) |
| `Space hr` | Reset hunk (works in visual mode too) |
| `Space hS` | Stage entire buffer |
| `Space hR` | Reset entire buffer |
| `Space hp` | Preview hunk (popup diff) |
| `Space hi` | Preview hunk inline |
| `Space hb` | Blame current line (full commit message) |
| `Space hd` | Diff this file |
| `Space tb` | Toggle line blame (persistent) |
| `Space td` | Toggle show deleted lines |

Gutter signs: `+` added, `~` changed, `_` deleted.

---

## Terminal

*Running builds, starting servers, executing commands without leaving Neovim.*

| Key / Command | Action |
|---------------|--------|
| `:terminal` | Open terminal in current window |
| `:sp \| terminal` | Open terminal in horizontal split |
| `:vs \| terminal` | Open terminal in vertical split |
| `i` | Enter terminal insert mode (start typing) |
| `Esc Esc` | Exit terminal mode (back to normal mode) |
| `C-h/j/k/l` | Move to another window from terminal |

**Typical workflow:** `:sp | terminal` to get a build pane below your editor. Run `cmake --build build`, read errors, `Esc Esc` then `C-k` to jump back to code.

---

## Debugging (DAP)

*Breakpoints, stepping through code. Requires a debug adapter (e.g., codelldb for C++).*

| Key | Action |
|-----|--------|
| `F5` | Start / Continue |
| `F1` | Step into |
| `F2` | Step over |
| `F3` | Step out |
| `Space b` | Toggle breakpoint |
| `Space B` | Set conditional breakpoint (prompts for condition) |
| `F7` | Toggle debug UI |

**Note:** The default kickstart debug config installs `delve` (Go debugger). For C++ debugging, you'll need to configure `codelldb` or `cppdbg` via mason-nvim-dap.

---

## Toggles

*Feature toggles available under `Space t`.*

| Key | Action |
|-----|--------|
| `Space th` | Toggle inlay hints (type annotations inline) |
| `Space tb` | Toggle git line blame |
| `Space td` | Toggle show deleted lines (git) |

---

## General & Maintenance

*Plugin management, help, discovery.*

| Key / Command | Action |
|---------------|--------|
| `Esc` | Clear search highlights |
| `Space sk` | Search all keymaps (if you forget something) |
| `:Lazy` | Plugin manager (update, status, clean) |
| `:Lazy update` | Update all plugins |
| `:Mason` | LSP/tool installer (status, install, update) |
| `:checkhealth` | Diagnose configuration issues |
| `:Tutor` | Built-in Neovim tutorial |
| `Space sh` | Search help documentation |

---

## Useful Vim Motions Cheat Sheet

*Not plugin-specific — just the essentials worth having on a card.*

| Key | Action |
|-----|--------|
| `gg` / `G` | Top / bottom of file |
| `{` / `}` | Previous / next paragraph |
| `%` | Jump to matching bracket |
| `*` / `#` | Search forward / backward for word under cursor |
| `ciw` | Change inner word |
| `dd` | Delete line |
| `yy` | Yank (copy) line |
| `p` / `P` | Paste after / before |
| `u` / `C-r` | Undo / redo |
| `.` | Repeat last change |
| `o` / `O` | New line below / above and enter insert |
| `A` | Append at end of line |
| `I` | Insert at beginning of line |
| `>>` / `<<` | Indent / dedent line |
| `=ap` | Auto-indent paragraph |
