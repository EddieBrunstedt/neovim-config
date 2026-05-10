-- Mini.pick: fuzzy picker and related keymaps

local pick = require 'mini.pick'
local extra = require 'mini.extra'

extra.setup()

pick.setup {
  window = {
    config = {
      anchor = 'SW',
      height = math.floor(0.5 * vim.o.lines),
      width = vim.o.columns,
      row = vim.o.lines - vim.o.cmdheight,
      col = 0,
    },
  },
}

-- NOTE: Leaving this here in case I want to customize the use of rg
-- local function files(cwd)
--   cwd = cwd or vim.fn.getcwd()
--   local source = { name = 'Files', cwd = cwd }
--   if vim.fn.executable 'rg' == 1 then
--     return pick.builtin.cli({
--       command = { 'rg', '--files', '--hidden', '--glob', '!.git', '--color=never' },
--     }, { source = source })
--   end
--   if vim.fn.executable 'fd' == 1 then
--     return pick.builtin.cli({
--       command = { 'fd', '--type=f', '--hidden', '--exclude', '.git', '--color=never' },
--     }, { source = source })
--   end
--   return pick.builtin.files(nil, { source = source })
-- end

vim.keymap.set('n', '<leader>sh', function() pick.builtin.help() end, { desc = 'Help' })
vim.keymap.set('n', '<leader>sk', function() extra.pickers.keymaps() end, { desc = 'Keymaps' })
vim.keymap.set('n', '<leader>sf', pick.builtin.files, { desc = 'Files' })
vim.keymap.set('n', '<leader>sg', function() pick.builtin.grep_live() end, { desc = 'Grep' })
vim.keymap.set('n', '<leader>sd', function() extra.pickers.diagnostic() end, { desc = 'Diagnostics' })
vim.keymap.set('n', '<leader>sr', function() pick.builtin.resume() end, { desc = 'Resume' })
vim.keymap.set('n', '<leader>s.', function() extra.pickers.oldfiles { current_dir = true } end, { desc = 'Recent files' })
vim.keymap.set('n', '<leader>sb', function() pick.builtin.buffers() end, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>/', function() extra.pickers.buf_lines { scope = 'current' } end, { desc = 'Buffer lines' })
vim.keymap.set('n', '<leader>s/', function() extra.pickers.buf_lines { scope = 'all' } end, { desc = 'Lines in open files' })
