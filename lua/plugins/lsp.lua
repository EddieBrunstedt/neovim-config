-- Language Server Protocol configuration
-- Provides IDE features: completion, go-to-definition, diagnostics, and more

require('fidget').setup {}

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local extra = require 'mini.extra'
    local lsp_picker = function(scope)
      return function() extra.pickers.lsp { scope = scope } end
    end
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    -- LSP keymaps
    map('<leader>ss', lsp_picker 'document_symbol', 'Document symbols')
    map('<leader>sS', lsp_picker 'workspace_symbol_live', 'Workspace symbols')
    map('grD', lsp_picker 'declaration', 'Goto declaration')
    map('gra', vim.lsp.buf.code_action, 'Code action', { 'n', 'x' })
    map('grd', lsp_picker 'definition', 'Goto definition')
    map('gri', lsp_picker 'implementation', 'Goto implementation')
    map('grn', vim.lsp.buf.rename, 'Rename')
    map('grr', lsp_picker 'references', 'Goto references')
    map('grt', lsp_picker 'type_definition', 'Goto type definition')

    local client = vim.lsp.get_client_by_id(event.data.client_id)

    -- Disable rust-analyzer's semantic tokens. After certain proc-macro-
    -- perturbing edits, r-a's analysis wedges and identifiers stay
    -- highlighted as `@lsp.type.unresolvedReference` until the LSP is
    -- restarted. Disabling just delta requests didn't help — the server's
    -- model itself goes bad. Treesitter still colors; diagnostics still
    -- work. Match both names: `rust_analyzer` (lspconfig), `rust-analyzer`
    -- (rustaceanvim).
    if client and (client.name == 'rust_analyzer' or client.name == 'rust-analyzer') then
      client.server_capabilities.semanticTokensProvider = nil
    end

    -- Document highlight: highlight symbol under cursor
    if client and client:supports_method('textDocument/documentHighlight', event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
        end,
      })
    end

    -- Inlay hints toggle
    if client and client:supports_method('textDocument/inlayHint', event.buf) then
      map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, 'Toggle inlay hints')
    end

    if _G.MiniClue ~= nil then _G.MiniClue.ensure_buf_triggers(event.buf) end
  end,
})

-- Diagnostics
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text = true,
  virtual_lines = false,
  jump = {
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float {
        bufnr = bufnr,
        scope = 'cursor',
        focus = false,
      }
    end,
  },
}

-- Language servers
---@type table<string, vim.lsp.Config>
local servers = {
  biome = {},
  gopls = {
    settings = {
      gopls = {
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
      },
    },
  },
  tailwindcss = {},

  -- Used to format Lua code through LSP formatting.
  stylua = {},

  -- Special Lua config for editing Neovim config and plugins.
  lua_ls = {
    on_init = function(client)
      client.server_capabilities.documentFormattingProvider = false -- Formatting is done by stylua.

      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
      end

      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
        runtime = {
          version = 'LuaJIT',
          path = { 'lua/?.lua', 'lua/?/init.lua' },
        },
        workspace = {
          checkThirdParty = false,
          library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
            '${3rd}/luv/library',
            '${3rd}/busted/library',
          }),
        },
      })
    end,
    ---@type lspconfig.settings.lua_ls
    settings = {
      Lua = {
        format = { enable = false }, -- Formatting is done by stylua.
      },
    },
  },
}

require('mason').setup {}
require('mason-lspconfig').setup { automatic_enable = false }

-- mason-lspconfig lets mason-tool-installer accept lspconfig names like lua_ls
-- and map them to Mason package names like lua-language-server.
local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
  -- External formatters used by conform.nvim.
  'prettier',
})
require('mason-tool-installer').setup { ensure_installed = ensure_installed }

for name, server in pairs(servers) do
  vim.lsp.config(name, server)
  vim.lsp.enable(name)
end
