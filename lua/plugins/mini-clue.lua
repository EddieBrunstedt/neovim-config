-- Mini.clue: keybinding hints popup

local miniclue = require 'mini.clue'

miniclue.setup {
  triggers = {
    -- Leader mappings
    { mode = { 'n', 'x' }, keys = '<Leader>' },
    { mode = { 'n', 'x' }, keys = 's' },
    { mode = 'n', keys = '[' },
    { mode = 'n', keys = ']' },
    { mode = 'i', keys = '<C-x>' },
    { mode = { 'n', 'x' }, keys = 'g' },
    { mode = { 'n', 'x' }, keys = "'" },
    { mode = { 'n', 'x' }, keys = '`' },
    { mode = { 'n', 'x' }, keys = '"' },
    { mode = { 'i', 'c' }, keys = '<C-r>' },
    { mode = 'n', keys = '<C-w>' },
    { mode = { 'n', 'x' }, keys = 'z' },
  },

  clues = {
    { mode = { 'n', 'x' }, keys = '<Leader>h', desc = 'Git' },
    { mode = 'n', keys = '<Leader>s', desc = 'Search' }, -- pickers are normal-mode only
    { mode = 'n', keys = '<Leader>t', desc = 'Toggle' },
    { mode = 'n', keys = '<Leader>x', desc = 'Diagnostics' },
    { mode = 'n', keys = '<Leader>y', desc = 'Yank' },
    { mode = { 'n', 'x' }, keys = 's', desc = 'LSP Actions' },

    miniclue.gen_clues.square_brackets(),
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),

    miniclue.set_mapping_desc('n', 'gx', ''), -- drop its very long description
  },

  window = {
    delay = 0,
    config = {
      border = 'rounded',
      width = 'auto',
    },
  },
}
