# Neovim Configuration Reference (WSL / kickstart.nvim)

Steps to take after running `setup-nvim-wsl.sh`. Assumes kickstart.nvim is
cloned to `~/.config/nvim` and Neovim has completed its initial plugin
bootstrap.

---

## 1. C++ autocomplete (clangd)

Open your `init.lua`:

```bash
nvim ~/.config/nvim/init.lua
```

Find the `servers` table. kickstart includes clangd commented out — uncomment
it:

```lua
local servers = {
  clangd = {},
  -- other servers...
}
```

To enable clang-tidy linting alongside autocomplete, expand the entry:

```lua
clangd = {
  cmd = { "clangd", "--clang-tidy" },
},
```

Save and restart Neovim. Mason will install clangd automatically on startup
because it's in the servers table. Verify from inside Neovim:

```
:Mason
```

### compile_commands.json

clangd requires a `compile_commands.json` at the project root to resolve
headers and provide accurate autocomplete. CMake generates this automatically:

```bash
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -B build
```

If the file ends up in `build/` rather than the project root, symlink it:

```bash
ln -s build/compile_commands.json compile_commands.json
```

Open a `.cpp` file in a project that has this file and autocomplete should be
active.

---

## 2. File browsing (neo-tree)

kickstart ships with Telescope (`<leader>sf` to search files, `<leader>sg` to
grep), which covers most navigation. For a sidebar tree, add neo-tree.

In `init.lua`, find the `require('lazy').setup(...)` plugins list and add:

```lua
{
  "nvim-neo-tree/neo-tree.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
},
```

Add a keymap near your other keymaps:

```lua
vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { desc = 'Toggle file tree' })
```

Save and restart Neovim. lazy.nvim will install neo-tree automatically.

---

## 3. Plugin lockfile (lazy-lock.json)

lazy.nvim generates a `lazy-lock.json` in `~/.config/nvim/` that records the
exact commit hash of every installed plugin. Committing this file to your
kickstart fork means a fresh install will reproduce your exact plugin versions
rather than pulling whatever is latest at that moment.

kickstart's default `.gitignore` excludes `lazy-lock.json` to simplify
upstream maintenance. Remove that exclusion from your fork.

### Setup

```bash
cd ~/.config/nvim

# Remove the lazy-lock.json line from .gitignore
nvim .gitignore

# Stage and commit the lockfile
git add lazy-lock.json
git commit -m "track lazy-lock.json for reproducible plugin versions"
git push
```

### On a fresh install

After cloning your fork and launching Neovim, lazy.nvim reads `lazy-lock.json`
and restores every plugin at the pinned commit automatically. No manual
intervention needed.

### Updating plugins

When you want to update, run from inside Neovim:

```
:Lazy update
```

This pulls the latest commits for all plugins and rewrites `lazy-lock.json`
with the new hashes. Commit the updated lockfile afterward:

```bash
cd ~/.config/nvim
git add lazy-lock.json
git commit -m "update plugins $(date +%Y-%m-%d)"
git push
```

Updates are deliberate and tracked rather than automatic on every install.

### Rolling back

If an update breaks something, check out the prior lockfile from git and run:

```
:Lazy restore
```

lazy.nvim will downgrade every plugin to the commits recorded in the lockfile.
This is the main advantage over a bare clone — you have a full history of your
plugin state and can roll back to any point in it.

---

## 4. Ongoing maintenance

### Update Mason-managed tools (clangd, etc.)

```
:MasonUpdate
```

Mason tools (LSP servers, linters, formatters) are managed separately from
plugins and are not pinned by the lockfile. Update them deliberately when you
want newer versions.

### Update system packages

```bash
sudo apt update && sudo apt upgrade -y
```

### Pull kickstart upstream changes

If the upstream kickstart.nvim repo ships changes you want, merge them into
your fork:

```bash
cd ~/.config/nvim
git remote add upstream https://github.com/nvim-lua/kickstart.nvim.git
git fetch upstream
git merge upstream/master
```

Resolve any conflicts (most likely in `init.lua`), then push. The remote only
needs to be added once — on subsequent merges just `fetch` and `merge`.
