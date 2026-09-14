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

-- Render: Preview the current file in a browser window.
-- Needs the external `render` tool on $PATH. Bang passes --save, which writes
-- the html beside the source instead of into the runtime dir.
vim.api.nvim_create_user_command('Render', function(opts)
  local file = vim.fn.expand '%:p'
  if file == '' then
    vim.notify('Render: buffer has no file', vim.log.levels.ERROR)
    return
  end
  if vim.fn.executable 'render' == 0 then
    vim.notify('Render: `render` not found on $PATH', vim.log.levels.ERROR)
    return
  end
  if vim.bo.modified then vim.cmd.write() end
  local cmd = opts.bang and { 'render', '--save', file } or { 'render', file }
  vim.system(cmd, { text = true }, function(res)
    if res.code ~= 0 then vim.schedule(function() vim.notify('Render: ' .. vim.trim(res.stderr), vim.log.levels.ERROR) end) end
  end)
end, { bang = true, desc = 'Preview buffer in a browser window' })
