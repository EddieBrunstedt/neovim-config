-- Flash: enhanced motion and navigation

require('flash').setup {}

-- stylua: ignore
vim.keymap.set({ 'n', 'x', 'o' }, 'S', function() require('flash').jump() end, { desc = 'Flash' })
vim.keymap.set('o', 'r', function() require('flash').remote() end, { desc = 'Remote Flash' })
vim.keymap.set({ 'o', 'x' }, 'R', function() require('flash').treesitter_search() end, { desc = 'Treesitter Search' })
vim.keymap.set('c', '<c-s>', function() require('flash').toggle() end, { desc = 'Toggle Flash Search' })
