-- Language Server Protocol configuration
-- Provides IDE features: completion, go-to-definition, diagnostics, and more

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'mason-org/mason.nvim', opts = {} },
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
      callback = function(event)
        local Snacks = require 'snacks'
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- LSP keymaps
        map('<leader>ss', Snacks.picker.lsp_symbols, 'Open Document Symbols')
        map('<leader>sS', Snacks.picker.lsp_workspace_symbols, 'Open Workspace Symbols')
        map('grD', Snacks.picker.lsp_declarations, '[G]oto [D]eclaration')
        map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
        map('grd', Snacks.picker.lsp_definitions, '[G]oto [D]efinition')
        map('gri', Snacks.picker.lsp_implementations, '[G]oto [I]mplementation')
        map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('grr', Snacks.picker.lsp_references, '[G]oto [R]eferences')
        map('grt', Snacks.picker.lsp_type_definitions, '[G]oto [T]ype Definition')

        -- Document highlight: highlight symbol under cursor
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
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
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    -- Diagnostics
    vim.diagnostic.config {
      update_in_insert = false,
      severity_sort = true,
      float = { border = 'rounded', source = 'if_many' },
      underline = { severity = { min = vim.diagnostic.severity.ERROR } },
      virtual_text = true,
      virtual_lines = false,
      jump = { float = true },
    }

    -- Language servers
    --  Capabilities are automatically extended by blink.cmp, no manual merging needed.
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
    }

    for server_name, server_config in pairs(servers) do
      vim.lsp.config(server_name, server_config)
      vim.lsp.enable(server_name)
    end

    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, { 'lua-language-server', 'stylua', 'prettier', 'tailwindcss-language-server' })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    -- Special Lua config for editing Neovim config and plugins
    vim.lsp.config('lua_ls', {
      on_init = function(client)
        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
            return
          end
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
      settings = { Lua = {} },
    })
    vim.lsp.enable 'lua_ls'
    vim.lsp.enable 'tailwindcss'
  end,
}
