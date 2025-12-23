-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
--  NEOVIM CONFIGURATION
--  Modular configuration entry point
-- ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

-- Core ──────────────────────────────────────────────────────────────────
require 'config.options'
require 'config.keymaps'
require 'config.autocmds'
require 'commands'

-- Plugins ───────────────────────────────────────────────────────────────
require 'config.lazy'

-- Appearance ────────────────────────────────────────────────────────────
require 'config.highlights'
