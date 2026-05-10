-- Plugin configuration entry point

local modules = {
  'plugins.colorscheme',
  'plugins.guess-indent',
  'plugins.gitsigns',
  'plugins.todo-comments',
  'plugins.mini',
  'plugins.pick',
  'plugins.oil',
  'plugins.quickfix',
  'plugins.flash',
  'plugins.autopairs',
  'plugins.completion',
  'plugins.lsp',
  'plugins.typescript',
  'plugins.conform',
  'plugins.treesitter',
  'plugins.indent-blankline',
  'plugins.debug',
  'plugins.clue',
}

for _, module in ipairs(modules) do
  require(module)
end
