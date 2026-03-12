-- Code formatting with conform.nvim

local should_format_on_save = true

local biome_config_files = { 'biome.json', 'biome.jsonc' }

local function has_biome_config(bufnr)
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  local dir = vim.fs.dirname(filepath)
  return vim.fs.find(biome_config_files, { path = dir, upward = true })[1] ~= nil
end

local function web_formatter(bufnr)
  if has_biome_config(bufnr) then
    return { 'biome' }
  end
  return { 'prettier' }
end

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
    {
      '<leader>tf',
      function()
        should_format_on_save = not should_format_on_save
        print('Should format on save: ' .. (should_format_on_save and 'True' or 'False'))
      end,
      desc = '[T]oggle [F]ormat on save',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      if not should_format_on_save then
        return nil
      end

      local disable_filetypes = { c = true, cpp = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      else
        return {
          timeout_ms = 500,
          lsp_format = 'fallback',
        }
      end
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
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
  },
}
