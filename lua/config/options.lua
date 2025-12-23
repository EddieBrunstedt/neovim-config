-- Core Neovim options and editor behavior

-- Leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Enable Nerd Font icons
vim.g.have_nerd_font = true

-- Indentation and line wrapping
vim.o.breakindent = true

-- Interface
vim.o.confirm = true
vim.o.cursorline = true
vim.o.list = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.scrolloff = 1
vim.o.showmode = false
vim.o.signcolumn = 'yes'

-- Search behavior
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.inccommand = 'split'

-- Mouse support
vim.o.mouse = 'a'
vim.o.mousescroll = 'ver:1,hor:6'

-- Window splits
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.winborder = 'rounded'

-- Timing
vim.o.timeoutlen = 300
vim.o.updatetime = 250

-- Persistence
vim.o.undofile = true

-- Whitespace characters
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Clipboard integration (deferred for faster startup)
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)
