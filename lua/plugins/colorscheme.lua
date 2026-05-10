-- Nightfox colorscheme

require('nightfox').setup {
  palettes = {
    all = {
      bg0 = '#1e1e1e',
      bg1 = '#000000',
    },
  },
  options = {
    styles = {
      comments = 'italic',
      keywords = 'bold',
      types = 'italic,bold',
    },
  },
}

vim.cmd.colorscheme 'duskfox'
vim.cmd.hi 'CursorLine guibg=#1e1e1e'
