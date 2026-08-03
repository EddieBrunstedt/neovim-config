-- Language Server Protocol configuration
-- Provides IDE features: completion, go-to-definition, diagnostics, and more

require('fidget').setup {}

-- Neovim defines some default LSP mappings on `gr...`/`gO`. This config uses
-- `s` as the single LSP prefix instead.
for _, key in ipairs { 'gO', 'gra', 'gri', 'grn', 'grr', 'grt', 'grx' } do
  pcall(vim.keymap.del, 'n', key)
end
pcall(vim.keymap.del, 'x', 'gra')

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local extra = require 'mini.extra'
    local lsp_picker = function(scope)
      return function() extra.pickers.lsp { scope = scope } end
    end

    -- `references`, narrowed to the current file. Compare realpaths so a symlinked
    -- buffer still matches the paths the server reports.
    local current_file_references = function()
      local current = vim.uv.fs_realpath(vim.api.nvim_buf_get_name(0))
      if current == nil then
        vim.notify('Current buffer has no file on disk', vim.log.levels.WARN)
        return
      end

      vim.lsp.buf.references(nil, {
        on_list = function(data)
          local items = vim.tbl_filter(function(item) return item.filename and vim.uv.fs_realpath(item.filename) == current end, data.items or {})
          if #items == 0 then
            vim.notify('No references in current file', vim.log.levels.INFO)
            return
          end

          data.items, data.title = items, 'References (current file)'
          vim.fn.setqflist({}, ' ', data)
          extra.pickers.list({ scope = 'quickfix' }, { source = { name = data.title } })
        end,
      })
    end

    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = desc })
    end

    -- LSP keymaps
    map('sd', lsp_picker 'definition', 'Goto definition')
    map('sD', lsp_picker 'declaration', 'Goto declaration')
    map('si', lsp_picker 'implementation', 'Goto implementation')
    map('sr', lsp_picker 'references', 'Goto references')
    map('sR', current_file_references, 'Goto references in current file')
    map('st', lsp_picker 'type_definition', 'Goto type definition')
    map('ss', lsp_picker 'document_symbol', 'Document symbols')
    map('sS', lsp_picker 'workspace_symbol_live', 'Workspace symbols')
    map('sa', vim.lsp.buf.code_action, 'Code action', { 'n', 'x' })
    map('sn', vim.lsp.buf.rename, 'Rename')
    map('sx', vim.lsp.codelens.run, 'Run codelens')

    local client = vim.lsp.get_client_by_id(event.data.client_id)

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
      map('sh', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, 'Inlay hints')
    end

    if _G.MiniClue ~= nil then _G.MiniClue.ensure_buf_triggers(event.buf) end
  end,
})

-- Diagnostics
vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = true },
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
  cssls = {},
  gdscript = {},
  html = {},
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
  marksman = {},

  -- Runs as `stylua --lsp`; formats Lua through LSP formatting.
  stylua = {},

  -- Special Lua config for editing Neovim config and plugins.
  lua_ls = {
    on_init = function(client)
      client.server_capabilities.documentFormattingProvider = false -- Formatting is done by stylua.

      if client.workspace_folders then
        local path = client.workspace_folders[1].name
        if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
      end

      local current_settings = client.config.settings --[[@as lspconfig.settings.lua_ls]]
      client.config.settings.Lua = vim.tbl_deep_extend('force', current_settings.Lua, {
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

-- Servers that ship with a toolchain outside the editor. Mason must not install
-- a second copy that would shadow them on nvim's PATH.
local toolchain_managed = {
  gdscript = true, -- built into the running Godot editor
}

local ensure_installed = vim.tbl_filter(function(name) return not toolchain_managed[name] end, vim.tbl_keys(servers))
vim.list_extend(ensure_installed, {
  -- Configured in plugins/tailwind.lua, but the binary still comes from Mason.
  'tailwindcss',

  -- Standalone formatter binaries that conform.nvim shells out to.
  'prettier',
  'dprint',
  'taplo',
  'shfmt',
  'yamlfmt',
})
require('mason-tool-installer').setup { ensure_installed = ensure_installed }

for name, server in pairs(servers) do
  vim.lsp.config(name, server)
  vim.lsp.enable(name)
end
