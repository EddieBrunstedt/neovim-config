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

    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
        local buf, filetype = args.buf, args.match

        -- Resolve the treesitter language for this filetype
        local language = vim.treesitter.language.get_lang(filetype)
        if not language then
          return
        end

        -- Check if parser exists and load it
        if not vim.treesitter.language.add(language) then
          return
        end

        -- Enable syntax highlighting and other treesitter features
        vim.treesitter.start(buf, language)

        -- Enable treesitter-based indentation
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
