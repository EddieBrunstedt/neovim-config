-- Code formatting with conform.nvim

local should_format_on_save = true

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
      css = { 'prettier' },
      html = { 'prettier' },
      javascript = { 'prettier' },
      javascriptreact = { 'prettier' },
      typescript = { 'prettier' },
      typescriptreact = { 'prettier' },
      markdown = { 'prettier' },
      vue = { 'prettier' },
    },
  },
}
