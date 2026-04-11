-- General keybindings (plugin-specific keymaps are in lua/plugins/)

-- Clear search highlight
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Save file
vim.keymap.set('i', '<C-s>', '<C-O>:update<CR>', { desc = 'Write buffer to file' })
vim.keymap.set('n', '<C-s>', ':update<CR>', { desc = 'Write buffer to file' })
vim.keymap.set('v', '<C-s>', '<C-C>:update<CR>', { desc = 'Write buffer to file' })

-- Buffer navigation
vim.keymap.set('n', '<leader><tab>', '<C-^>', { desc = 'Go to previous buffer' })

-- Diagnostics
vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = 'Show diagnostic [L]ine' })
vim.keymap.set('n', '<leader>xd', function()
  vim.diagnostic.setloclist()
end, { desc = 'Buffer [D]iagnostics to loclist' })
vim.keymap.set('n', '<leader>xD', function()
  vim.diagnostic.setqflist()
end, { desc = 'Workspace [D]iagnostics to quickfix' })

-- Yank utilities (see commands.lua)
vim.keymap.set('n', '<leader>yb', '<CMD>:BufferYank<CR>', { desc = '[Y]ank [B]uffer contents' })
vim.keymap.set('n', '<leader>yp', '<CMD>FilePathYank<CR>', { desc = '[Y]ank [P]ath of current file' })

-- Terminal
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
