<div align="center">

# Neovim Configuration

_A modular Neovim setup built for flexibility and extensibility_

</div>

---

## Philosophy

This configuration embraces a modular architecture that makes it easy to experiment with new plugins, update existing ones, or strip down to essentials. Each component lives in its own file, making the config maintainable and understandable at a glance.

## Structure

```
~/.config/nvim/
├── init.lua                # Entry point - loads everything
├── lua/
│   ├── config/
│   │   ├── lazy.lua        # Plugin manager setup
│   │   ├── options.lua     # Editor settings
│   │   ├── keymaps.lua     # Key bindings
│   │   ├── autocmds.lua    # Autocommands
│   │   └── highlights.lua  # Custom highlights
│   ├── plugins/            # Plugin configurations (auto-loaded)
│   └── commands.lua        # Custom commands
└── after/
    └── ftplugin/           # Filetype-specific settings
```

### Core Configuration

The `lua/config/` directory contains the foundation:

- **options.lua** — Editor behavior and UI preferences
- **keymaps.lua** — Keybinding definitions
- **autocmds.lua** — Event-driven automation
- **highlights.lua** — Theme and syntax customization
- **lazy.lua** — Plugin manager bootstrap and configuration

### Plugin System

Plugins are managed by [lazy.nvim](https://github.com/folke/lazy.nvim) and organized as individual files in `lua/plugins/`.

## Installation

Neovim's configurations are located under the following paths, depending on your OS:

| OS                   | PATH                                      |
| :------------------- | :---------------------------------------- |
| Linux, MacOS         | `$XDG_CONFIG_HOME/nvim`, `~/.config/nvim` |
| Windows (cmd)        | `%localappdata%\nvim\`                    |
| Windows (powershell) | `$env:LOCALAPPDATA\nvim\`                 |

```bash
# Clone this configuration
git clone https://gitlab.com/EddieBrunstedt/neovim-config.git ~/.config/nvim

# Launch Neovim - plugins will install automatically
nvim
```

## Maintenance

### Plugin Management

```bash
# Update plugins
:Lazy sync

# Check plugin status
:Lazy

# Check health
:checkhealth
```

### Fresh Install

To completely reset and reinstall all plugins from scratch, delete the data directory where Neovim stores plugin files:

| OS                   | PATH                           |
| :------------------- | :----------------------------- |
| Linux, MacOS         | `~/.local/share/nvim/`         |
| Windows (cmd)        | `%localappdata%\nvim-data\`    |
| Windows (powershell) | `$env:LOCALAPPDATA\nvim-data\` |

```bash
# Linux/MacOS
rm -rf ~/.local/share/nvim/

# Windows (PowerShell)
Remove-Item -Recurse -Force $env:LOCALAPPDATA\nvim-data\
```

On next launch, all plugins will be reinstalled automatically.
