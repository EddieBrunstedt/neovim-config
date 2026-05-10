-- Plugin-specific globals read during plugin startup
vim.g.db_ui_use_nerd_fonts = 1

local function gh(repo) return 'https://github.com/' .. repo end

local function run_build(name, cmd, cwd)
  local result = vim.system(cmd, { cwd = cwd, text = true }):wait()
  if result.code ~= 0 then
    local stderr = result.stderr or ''
    local stdout = result.stdout or ''
    local output = stderr ~= '' and stderr or stdout
    if output == '' then output = 'No output from build command.' end
    vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
  end
end

vim.api.nvim_create_autocmd('PackChanged', {
  desc = 'Run plugin build hooks after vim.pack installs or updates plugins',
  group = vim.api.nvim_create_augroup('pack-build-hooks', { clear = true }),
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    if kind ~= 'install' and kind ~= 'update' then return end

    if name == 'LuaSnip' then
      if vim.fn.has 'win32' ~= 1 and vim.fn.executable 'make' == 1 then run_build(name, { 'make', 'install_jsregexp' }, ev.data.path) end
      return
    end

    if name == 'nvim-treesitter' then
      if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
      vim.cmd 'TSUpdate'
      return
    end
  end,
})

vim.pack.add({
  -- Libraries / shared dependencies
  gh 'nvim-lua/plenary.nvim',
  gh 'nvim-neotest/nvim-nio',

  -- Mason / LSP / DAP foundations
  gh 'mason-org/mason.nvim',
  gh 'neovim/nvim-lspconfig',
  gh 'mason-org/mason-lspconfig.nvim',
  gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
  gh 'mfussenegger/nvim-dap',
  gh 'jay-babu/mason-nvim-dap.nvim',

  -- UI / UX
  -- gh 'EdenEast/nightfox.nvim',
  -- gh 'scottmckendry/cyberdream.nvim',
  -- gh 'kepano/flexoki-neovim',
  gh 'folke/tokyonight.nvim',
  gh 'NMAC427/guess-indent.nvim',
  gh 'folke/flash.nvim',
  gh 'folke/todo-comments.nvim',
  gh 'lewis6991/gitsigns.nvim',
  gh 'lukas-reineke/indent-blankline.nvim',
  gh 'nvim-mini/mini.nvim',
  gh 'stevearc/oil.nvim',
  gh 'stevearc/quicker.nvim',
  gh 'windwp/nvim-autopairs',

  -- Completion / snippets
  { src = gh 'L3MON4D3/LuaSnip', version = vim.version.range '2.*' },
  { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' },

  -- Formatting / syntax / languages
  gh 'j-hui/fidget.nvim',
  { src = gh 'mrcjkb/rustaceanvim', version = vim.version.range '^9' },
  { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' },
  gh 'pmizio/typescript-tools.nvim',
  gh 'stevearc/conform.nvim',

  -- Debugging
  gh 'leoluz/nvim-dap-go',
  gh 'rcarriga/nvim-dap-ui',
  gh 'theHamsta/nvim-dap-virtual-text',

  -- Database
  gh 'tpope/vim-dadbod',
  gh 'kristijanhusak/vim-dadbod-ui',
  gh 'kristijanhusak/vim-dadbod-completion',
}, {
  -- Source plugin/ files immediately. This keeps Vimscript-style plugins
  -- such as vim-dadbod-ui and rustaceanvim behaving like normal packages.
  load = true,
  -- Install missing plugins without prompting.
  confirm = false,
})

require 'plugins'
