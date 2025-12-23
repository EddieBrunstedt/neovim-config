-- Custom user commands

-- FilePathYank: Copy relative path of current file
vim.api.nvim_create_user_command('FilePathYank', function()
  local path = vim.fn.expand '%:.'
  vim.fn.setreg('+', path)
  vim.notify('Copied "' .. path .. '" to clipboard')
end, {})

-- BufferYank: Copy entire buffer contents
vim.api.nvim_create_user_command('BufferYank', function()
  local content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), '\n')
  vim.fn.setreg('+', content)
  vim.notify 'Copied buffer to clipboard'
end, {})
