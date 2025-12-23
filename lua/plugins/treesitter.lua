-- Treesitter for advanced syntax highlighting and code analysis

return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  branch = 'main',
  dependencies = {
    'nvim-treesitter/nvim-treesitter-context',
  },
  config = function()
    local parsers = {
      'bash',
      'c',
      'css',
      'diff',
      'html',
      'javascript',
      'latex',
      'lua',
      'luadoc',
      'markdown',
      'markdown_inline',
      'query',
      'regex',
      'rust',
      'scss',
      'svelte',
      'tsx',
      'typst',
      'vim',
      'vimdoc',
      'vue',
      'zig',
    }
    require('nvim-treesitter').install(parsers)
  end,
}
