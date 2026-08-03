-- Tailwind CSS tooling: LSP integration, class concealment, and colour hints

require('tailwind-tools').setup {
  -- Configure the server below via vim.lsp, not the plugin's deprecated
  -- nvim-lspconfig path.
  server = { override = false },
  document_color = { enabled = false }, -- on demand via :TailwindColorEnable
  conceal = {
    enabled = false,
    symbol = '…',
  },
}

-- Mason installs the server binary (see plugins/lsp.lua); this module owns its
-- configuration and startup.
vim.lsp.config('tailwindcss', {
  capabilities = {
    textDocument = {
      colorProvider = {
        dynamicRegistration = true,
      },
    },
  },
  settings = {
    tailwindCSS = {
      includeLanguages = require('tailwind-tools.filetypes').get_server_map(),
    },
  },
})
vim.lsp.enable 'tailwindcss'

vim.keymap.set('n', '<leader>tc', '<cmd>TailwindConcealToggle<CR>', { desc = 'Tailwind classes' })
