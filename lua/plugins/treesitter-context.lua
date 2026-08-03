-- Show the current Treesitter scope at the top of the window.

require('treesitter-context').setup {
  enable = true,
  -- Above Zen Mode's editor window (40), below normal floats (50). The default
  -- of 20 hides the context entirely in Zen Mode.
  zindex = 45,
}
