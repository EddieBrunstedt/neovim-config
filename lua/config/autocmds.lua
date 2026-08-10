-- Autocommands for automatic event-driven actions

-- Briefly highlight yanked text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- Re-even splits after the terminal is resized. Shrinking collapses every
-- non-current window to a single column and growing hands the reclaimed space
-- to whichever window is last, so the old layout is gone by the time we run.
-- On by default; toggle per-session with <leader>te.
vim.api.nvim_create_autocmd('VimResized', {
  desc = 'Equalize splits when the terminal is resized',
  group = vim.api.nvim_create_augroup('equalize-splits', { clear = true }),
  callback = function()
    if vim.g.equalize_splits == false then return end
    local tab = vim.api.nvim_get_current_tabpage()
    vim.cmd('noautocmd tabdo wincmd =')
    vim.api.nvim_set_current_tabpage(tab)
  end,
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
