-- Oil: file explorer as a buffer

return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    default_file_explorer = true,
    view_options = {
      show_hidden = true,
    },
    keymaps = {
      ['<C-s>'] = false,
      ['<C-h>'] = false,
      ['<C-t>'] = false,
    },
  },
  keys = { { '-', '<CMD>Oil<CR>', desc = 'Open parent directory' } },
  lazy = false,
}
