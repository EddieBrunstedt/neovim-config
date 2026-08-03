require('nightfox').setup {
  palettes = {
    all = {
      bg0 = '#1C1B1A',
      bg1 = '#100F0F',
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

vim.cmd.colorscheme 'nightfox'
