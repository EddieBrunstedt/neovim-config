-- Code formatting with conform.nvim

local should_format_on_save = true

-- Filetypes formatted automatically on save.
local format_on_save_filetypes = {
  css = true,
  html = true,
  javascript = true,
  javascriptreact = true,
  json = true,
  jsonc = true,
  lua = true,
  markdown = true,
  rust = true,
  toml = true,
  typescript = true,
  typescriptreact = true,
  yaml = true,
}

local biome_config_files = { 'biome.json', 'biome.jsonc' }

-- A project shipping one of these has chosen prettier; honour that rather than
-- reformatting against biome's style and fighting the project's own CI.
local prettier_config_files = {
  '.prettierrc',
  '.prettierrc.json',
  '.prettierrc.json5',
  '.prettierrc.yaml',
  '.prettierrc.yml',
  '.prettierrc.toml',
  '.prettierrc.js',
  '.prettierrc.mjs',
  '.prettierrc.cjs',
  '.prettierrc.ts',
  '.prettierrc.mts',
  '.prettierrc.cts',
  'prettier.config.js',
  'prettier.config.mjs',
  'prettier.config.cjs',
  'prettier.config.ts',
  'prettier.config.mts',
  'prettier.config.cts',
}

local function has_config(bufnr, names)
  local dir = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
  return vim.fs.find(names, { path = dir, upward = true })[1] ~= nil
end

-- An explicit project config wins; with no project preference, use biome.
local function web_formatter(bufnr)
  if has_config(bufnr, biome_config_files) then return { 'biome' } end
  if has_config(bufnr, prettier_config_files) then return { 'prettier' } end
  return { 'biome' }
end

require('conform').setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    if not should_format_on_save then return nil end
    if not format_on_save_filetypes[vim.bo[bufnr].filetype] then return nil end
    return { timeout_ms = 5000 }
  end,
  default_format_opts = {
    lsp_format = 'fallback',
  },
  formatters = {
    -- biome's HTML formatter is opt-in and the flag is only accepted after the
    -- `format` subcommand, so `prepend_args` cannot be used. Rebuilding the args
    -- means restating the builtin's indent passthrough for config-less projects.
    biome = {
      args = function(self, ctx)
        local args = { 'format', '--html-formatter-enabled=true', '--stdin-file-path', '$FILENAME' }
        if not self:cwd(ctx) then
          vim.list_extend(args, {
            '--indent-style',
            vim.bo[ctx.buf].expandtab and 'space' or 'tab',
            '--indent-width',
            ctx.shiftwidth,
          })
        end
        return args
      end,
    },

    -- dprint formats nothing and exits 0 with no config, so a machine without
    -- ~/.config/dprint would silently stop formatting Markdown. Fall back to the
    -- config shipped here, but let a project's own dprint.json win.
    dprint = {
      args = function(self, ctx)
        -- dprint rejects an absolute path that does not exist on disk yet (unnamed
        -- buffers, a new file's first save), but accepts any relative one.
        if self:cwd(ctx) then return { 'fmt', '--stdin', '$RELATIVE_FILEPATH' } end
        return { 'fmt', '--config', vim.fn.stdpath 'config' .. '/dprint.jsonc', '--stdin', '$RELATIVE_FILEPATH' }
      end,
    },

    taplo = {
      args = { 'fmt', '--option', 'inline_table_expand=false', '--stdin-filepath', '$FILENAME', '-' },
    },
  },
  formatters_by_ft = {
    css = web_formatter,
    html = web_formatter,
    javascript = web_formatter,
    javascriptreact = web_formatter,
    json = web_formatter,
    jsonc = web_formatter,
    markdown = { 'dprint' },
    sh = { 'shfmt' },
    toml = { 'taplo' },
    typescript = web_formatter,
    typescriptreact = web_formatter,
    yaml = { 'yamlfmt' }, -- biome has no YAML formatter
  },
}

vim.keymap.set({ 'n', 'v' }, '<leader>f', function() require('conform').format { async = true } end, { desc = 'Format buffer' })

vim.keymap.set('n', '<leader>tf', function()
  should_format_on_save = not should_format_on_save
  vim.notify('Format on save: ' .. (should_format_on_save and 'on' or 'off'))
end, { desc = 'Toggle format on save' })
