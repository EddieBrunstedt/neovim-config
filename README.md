<div align="center">

# Neovim Configuration

_A modular Neovim 0.12+ setup built for flexibility and extensibility_

</div>

---

## Philosophy

This configuration embraces a modular architecture that makes it easy to experiment with new plugins, update existing ones, or strip down to essentials. Each component lives in its own file, making the config maintainable and understandable at a glance.

## Requirements

- Neovim 0.12 or newer
- `git` for `vim.pack`
- Common tooling checked by `:checkhealth`: `make`, `unzip`, `rg`
- Optional language/tooling dependencies are installed through Mason where configured

## Structure

```
~/.config/nvim/
├── init.lua                 # Entry point - loads core config, plugins, highlights
├── nvim-pack-lock.json      # vim.pack lockfile (keep under version control)
├── lua/
│   ├── config/
│   │   ├── pack.lua         # Built-in vim.pack plugin specs and build hooks
│   │   ├── options.lua      # Editor settings
│   │   ├── keymaps.lua      # Key bindings
│   │   ├── autocmds.lua     # Autocommands
│   │   ├── highlights.lua   # Custom highlights
│   │   └── health.lua       # :checkhealth integration
│   ├── plugins/
│   │   ├── init.lua         # Loads plugin configuration modules
│   │   └── *.lua            # Individual plugin configurations
│   └── commands.lua         # Custom commands
└── after/
    └── ftplugin/            # Filetype-specific settings
```

### Core Configuration

The `lua/config/` directory contains the foundation:

- **options.lua** — Editor behavior and UI preferences
- **keymaps.lua** — Keybinding definitions
- **autocmds.lua** — Event-driven automation
- **highlights.lua** — Theme and syntax customization
- **health.lua** — Custom health checks
- **pack.lua** — Built-in `vim.pack` setup, plugin installation, and build hooks

### Plugin System

Plugins are managed by Neovim's built-in `vim.pack` and declared in `lua/config/pack.lua`. Plugin setup code lives in `lua/plugins/` and is loaded by `lua/plugins/init.lua`.

The `nvim-pack-lock.json` lockfile pins plugin revisions for reproducible installs and should be committed with the config.

## Installation

Neovim's configurations are located under the following paths, depending on your OS:

| OS                   | PATH                                      |
| :------------------- | :---------------------------------------- |
| Linux, macOS         | `$XDG_CONFIG_HOME/nvim`, `~/.config/nvim` |
| Windows (cmd)        | `%localappdata%\nvim\`                    |
| Windows (powershell) | `$env:LOCALAPPDATA\nvim\`                 |

```bash
# Clone this configuration
git clone https://github.com/EddieBrunstedt/neovim-config.git ~/.config/nvim

# Launch Neovim - plugins will install automatically
nvim
```

## Maintenance

### Plugin Management

```vim
" Update plugins. Review the update buffer, then :write to confirm or :quit to cancel.
:lua vim.pack.update()

" Inspect plugin status without downloading updates.
:lua vim.pack.update(nil, { offline = true })

" Check health.
:checkhealth
```

### Fresh Install / Reset

`vim.pack` stores managed plugins under Neovim's data directory at `site/pack/core/opt`:

| OS                   | Plugin path                                                   |
| :------------------- | :------------------------------------------------------------ |
| Linux, macOS         | `~/.local/share/nvim/site/pack/core/opt/`                     |
| Windows (cmd)        | `%localappdata%\nvim-data\site\pack\core\opt\`            |
| Windows (powershell) | `$env:LOCALAPPDATA\nvim-data\site\pack\core\opt\`         |

Delete that directory to force plugins to reinstall from `nvim-pack-lock.json` on next launch:

```bash
# Linux/macOS
rm -rf ~/.local/share/nvim/site/pack/core/opt/

# Windows (PowerShell)
Remove-Item -Recurse -Force $env:LOCALAPPDATA\nvim-data\site\pack\core\opt\
```

For a full Neovim data reset, remove the entire data directory (`~/.local/share/nvim/` or `%localappdata%\nvim-data\`).
