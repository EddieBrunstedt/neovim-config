-- Plugin configuration entry point

local modules = {
  'plugins.colorscheme',
  'plugins.guess-indent',
  'plugins.gitsigns',
  'plugins.todo-comments',
  'plugins.zen-mode',
  'plugins.mini',
  'plugins.mini-pick',
  'plugins.oil',
  'plugins.quickfix',
  'plugins.flash',
  'plugins.autopairs',
  'plugins.completion',
  'plugins.lsp',
  'plugins.tailwind',
  'plugins.rust',
  'plugins.typescript',
  'plugins.conform',
  'plugins.treesitter',
  'plugins.treesitter-context',
  'plugins.indent-blankline',
  'plugins.debug',
  'plugins.mini-clue',
}

for _, module in ipairs(modules) do
  require(module)
end
