-- Zen Mode: distraction-free focused editing

require('zen-mode').setup {}

vim.keymap.set('n', '<leader>tz', '<cmd>ZenMode<CR>', { desc = 'Zen mode' })
