-- Keybinding hints popup

require('which-key').setup {
  delay = 0,
  icons = { mappings = vim.g.have_nerd_font },
  spec = {
    { '<leader>h', group = 'Git', mode = { 'n', 'v' } },
    { '<leader>s', group = '[S]earch' },
    { '<leader>t', group = '[T]oggle' },
    { '<leader>x', group = 'Diagno[X]tics' },
    { '<leader>y', group = '[Y]ank' },
    { 'gr', group = 'LSP Actions', mode = { 'n' } },
  },
}
