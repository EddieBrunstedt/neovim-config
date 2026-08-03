-- Rust via rustaceanvim, which resolves rust-analyzer through rustup rather
-- than Mason. rustaceanvim reads `vim.g.rustaceanvim` lazily on FileType, so
-- setting it here (after vim.pack.add has sourced its plugin/ files) is fine.

vim.g.rustaceanvim = {
  server = {
    default_settings = {
      ['rust-analyzer'] = {
        workspace = {
          symbol = {
            search = {
              -- `workspace` scope still pulls in the extern prelude (see
              -- ide-db/src/symbol_index.rs `world_symbols`), so these only
              -- narrow; the real filtering happens client-side below.
              scope = 'workspace',
              kind = 'all_symbols', -- 'only_types' drops functions/consts
              excludeImports = true,
              -- `world_symbols` interleaves workspace and dep matches before
              -- truncating, so the default 128 can drop real workspace hits.
              limit = 1024,
            },
          },
        },
      },
    },
  },
}

-- Workspace symbols, restricted to the cargo workspace root. rust-analyzer's
-- workspace_symbol always includes dep symbols via extern_prelude_symbols and
-- no server setting disables it, so the filtering has to happen here.
local function workspace_symbol_picker()
  local MiniPick = require 'mini.pick'
  local MiniIcons = _G.MiniIcons

  local client = vim.lsp.get_clients({ name = 'rust-analyzer', bufnr = 0 })[1]
  if client == nil or client.root_dir == nil then
    vim.notify('rust-analyzer not attached to current buffer', vim.log.levels.WARN)
    return
  end
  local root_prefix = client.root_dir:gsub('/$', '') .. '/'

  local lsp_opts = {
    on_list = function(data)
      local items = {}
      for _, item in ipairs(data.items or {}) do
        if item.filename and vim.startswith(item.filename, root_prefix) then
          item.text, item.path = item.text or '', item.filename
          if MiniIcons and type(item.kind) == 'string' then
            local icon = MiniIcons.get('lsp', item.kind)
            item.text = icon .. ' ' .. item.text
          end
          table.insert(items, item)
        end
      end
      if MiniPick.is_picker_active() then MiniPick.set_picker_items(items, { do_match = false }) end
    end,
  }

  MiniPick.start {
    source = {
      name = 'LSP (workspace, filtered)',
      items = {},
      match = function(_, _, query)
        if #query == 0 then return MiniPick.set_picker_items({}, { do_match = false }) end
        local win_id = MiniPick.get_picker_state().windows.target
        local buf_id = vim.api.nvim_win_get_buf(win_id)
        vim.api.nvim_buf_call(buf_id, function() vim.lsp.buf.workspace_symbol(table.concat(query), lsp_opts) end)
      end,
      choose = function(item)
        MiniPick.default_choose(item)
        -- Same workaround mini.extra uses: forces relative paths in `:buffers`,
        -- which `default_choose` alone fails to do from inside an `on_list`.
        vim.fn.chdir(vim.fn.getcwd())
      end,
    },
  }
end

-- Overrides the generic `sS` from plugins/lsp.lua. Relies on this module being
-- required after 'plugins.lsp' in plugins/init.lua, so its LspAttach callback
-- runs second and its buffer-local mapping wins.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('rust-keymaps', { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.name == 'rust-analyzer' then
      vim.keymap.set('n', 'sS', workspace_symbol_picker, {
        buffer = event.buf,
        desc = 'Workspace symbols (filtered)',
      })
    end
  end,
})
