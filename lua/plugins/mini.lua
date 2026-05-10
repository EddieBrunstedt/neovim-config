-- Mini.nvim: text objects, surround, and statusline

require('mini.ai').setup {
  -- Avoid conflicts with Neovim 0.12 built-in treesitter incremental selection mappings.
  mappings = {
    around_next = 'aa',
    inside_next = 'ii',
  },
  n_lines = 500,
}

require('mini.icons').setup()

require('mini.surround').setup {
  mappings = {
    add = 'sa',
    delete = 'sd',
    find = 'sf',
    find_left = 'sF',
    highlight = 'sh',
    replace = 'sr',
  },
}

local statusline = require 'mini.statusline'
statusline.setup { use_icons = vim.g.have_nerd_font }

---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function() return '%2l:%-2v' end
