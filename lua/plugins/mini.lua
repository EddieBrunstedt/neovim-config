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
MiniIcons.mock_nvim_web_devicons()

require('mini.bracketed').setup {
  -- Disabled: gitsigns owns ]c/[c for git changes.
  comment = { suffix = '' },
}

require('mini.surround').setup {
  mappings = {
    add = 'ys',
    delete = 'ds',
    find = '',
    find_left = '',
    highlight = '',
    replace = 'cs',
    suffix_last = '',
    suffix_next = '',
  },
}

-- Keep Flash on `S`; use `gS` for adding surroundings to a visual selection.
pcall(vim.keymap.del, 'x', 'ys')
vim.keymap.set('x', 'gS', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { desc = 'Add surrounding to selection', silent = true })
vim.keymap.set('n', 'yss', 'ys_', { desc = 'Add surrounding to line', remap = true })

local statusline = require 'mini.statusline'
statusline.setup { use_icons = vim.g.have_nerd_font }

---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function() return '%2l:%-2v' end
