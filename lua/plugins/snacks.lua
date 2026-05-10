-- Snacks: fuzzy picker and utilities

local Snacks = require 'snacks'

Snacks.setup {
  picker = {
    hidden = true,
    layout = {
      preset = 'ivy',
      cycle = false,
    },
    layouts = {
      ivy = {
        layout = {
          box = 'vertical',
          backdrop = false,
          row = -1,
          width = 0,
          height = 0.5,
          border = 'top',
          title = ' {title} {live} {flags}',
          title_pos = 'left',
          { win = 'input', height = 1, border = 'bottom' },
          {
            box = 'horizontal',
            { win = 'list', border = 'none' },
            { win = 'preview', title = '{preview}', width = 0.5, border = 'left' },
          },
        },
      },
      vertical = {
        layout = {
          backdrop = false,
          width = 0.8,
          min_width = 80,
          height = 0.8,
          min_height = 30,
          box = 'vertical',
          border = 'rounded',
          title = '{title} {live} {flags}',
          title_pos = 'center',
          { win = 'input', height = 1, border = 'bottom' },
          { win = 'list', border = 'none' },
          { win = 'preview', title = '{preview}', height = 0.4, border = 'top' },
        },
      },
    },
    formatters = {
      file = {
        filename_first = true,
        truncate = 80,
      },
    },
  },
}

vim.keymap.set('n', '<leader>sh', function() Snacks.picker.help() end, { desc = '[S]earch [H]elp' })

vim.keymap.set('n', '<leader>sk', function() Snacks.picker.keymaps() end, { desc = '[S]earch [K]eymaps' })

vim.keymap.set('n', '<leader>sf', function() Snacks.picker.files { hidden = true } end, { desc = '[S]earch [F]iles' })

vim.keymap.set('n', '<leader>ss', function() Snacks.picker.pickers() end, { desc = '[S]earch [S]elect Snacks' })

vim.keymap.set({ 'n', 'x' }, '<leader>sw', function() Snacks.picker.grep_word() end, { desc = '[S]earch current [W]ord' })

vim.keymap.set('n', '<leader>sg', function() Snacks.picker.grep() end, { desc = '[S]earch by [G]rep' })

vim.keymap.set('n', '<leader>sd', function() Snacks.picker.diagnostics() end, { desc = '[S]earch [D]iagnostics' })

vim.keymap.set('n', '<leader>sr', function() Snacks.picker.resume() end, { desc = '[S]earch [R]esume' })

vim.keymap.set('n', '<leader>s.', function() Snacks.picker.recent() end, { desc = '[S]earch Recent Files ("." for repeat)' })

vim.keymap.set('n', '<leader><leader>', function() Snacks.picker.buffers() end, { desc = '[ ] Find existing buffers' })

vim.keymap.set('n', '<leader>/', function() Snacks.picker.lines {} end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>s/', function() Snacks.picker.grep_buffers() end, { desc = '[S]earch [/] in Open Files' })

vim.keymap.set('n', '<leader>sn', function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, { desc = '[S]earch [N]eovim files' })
