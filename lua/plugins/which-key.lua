-- Keybinding hints popup

return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    delay = 0,
    icons = { mappings = vim.g.have_nerd_font },
    spec = {
      { '<leader>g', group = '[G]it', mode = { 'n', 'v' } },
      { '<leader>h', group = '[H]ttp' },
      { '<leader>s', group = '[S]earch' },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>x', group = 'Diagno[X]tics' },
      { '<leader>y', group = '[Y]ank' },
      { 'gr', group = 'LSP Actions', mode = { 'n' } },
    },
  },
}
