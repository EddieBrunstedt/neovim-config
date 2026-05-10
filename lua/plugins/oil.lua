-- Oil: file explorer as a buffer

require('oil').setup {
  default_file_explorer = true,
  view_options = {
    show_hidden = true,
  },
  keymaps = {
    ['<C-s>'] = false,
    ['<C-h>'] = false,
    ['<C-t>'] = false,
  },
}

vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
