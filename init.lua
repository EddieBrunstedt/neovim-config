-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  NEOVIM CONFIGURATION
--  Modular configuration entry point
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

vim.loader.enable()

-- Core ──────────────────────────────────────────────────────────────────
require 'config.options'
require 'config.keymaps'
require 'config.autocmds'
require 'commands'

-- Plugins ───────────────────────────────────────────────────────────────
require 'config.pack'

-- Appearance ────────────────────────────────────────────────────────────
require 'config.highlights'
