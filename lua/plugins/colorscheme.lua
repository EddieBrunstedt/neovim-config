-- require('nightfox').setup {
--   palettes = {
--     all = {
--       bg0 = '#1e1e1e',
--       bg1 = '#000000',
--     },
--   },
--   options = {
--     styles = {
--       comments = 'italic',
--       keywords = 'bold',
--       types = 'italic,bold',
--     },
--   },
-- }

require('cyberdream').setup {
  italic_comments = true,
  colors = { bg = '#100F0F' },
}

vim.cmd.colorscheme 'cyberdream'
