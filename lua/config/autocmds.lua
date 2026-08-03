-- Autocommands for automatic event-driven actions

-- Briefly highlight yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- Wrap Markdown visually only; the file keeps one line per paragraph.
vim.api.nvim_create_autocmd('FileType', {
  desc = 'Soft-wrap Markdown, aligning wrapped list text',
  group = vim.api.nvim_create_augroup('markdown-soft-wrap', { clear = true }),
  pattern = { 'markdown' },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
    vim.opt_local.breakindent = true
    vim.opt_local.breakindentopt = 'list:-1'
    vim.opt_local.showbreak = ''
  end,
})
