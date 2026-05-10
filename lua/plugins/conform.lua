-- Code formatting with conform.nvim

local should_format_on_save = true

local format_on_save_filetypes = {
  -- Enable filetypes here to format them automatically on save.
  lua = true,
  rust = true,
  -- python = true,
}

local biome_config_files = { 'biome.json', 'biome.jsonc' }

local function has_biome_config(bufnr)
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  local dir = vim.fs.dirname(filepath)
  return vim.fs.find(biome_config_files, { path = dir, upward = true })[1] ~= nil
end

local function web_formatter(bufnr)
  if has_biome_config(bufnr) then return { 'biome' } end
  return { 'prettier' }
end

require('conform').setup {
  notify_on_error = false,
  format_on_save = function(bufnr)
    if not should_format_on_save then return nil end

    if format_on_save_filetypes[vim.bo[bufnr].filetype] then
      return { timeout_ms = 500 }
    else
      return nil
    end
  end,
  default_format_opts = {
    lsp_format = 'fallback',
  },
  formatters_by_ft = {
    sh = { 'shfmt' },
    css = web_formatter,
    html = web_formatter,
    json = web_formatter,
    jsonc = web_formatter,
    javascript = web_formatter,
    javascriptreact = web_formatter,
    typescript = web_formatter,
    typescriptreact = web_formatter,
    vue = web_formatter,
    markdown = { 'prettier' },
  },
}

vim.keymap.set({ 'n', 'v' }, '<leader>f', function() require('conform').format { async = true } end, { desc = '[F]ormat buffer' })

vim.keymap.set('n', '<leader>tf', function()
  should_format_on_save = not should_format_on_save
  print('Should format on save: ' .. (should_format_on_save and 'True' or 'False'))
end, { desc = '[T]oggle [F]ormat on save' })
