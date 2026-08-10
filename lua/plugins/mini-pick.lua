-- Mini.pick: fuzzy picker and related keymaps

local pick = require 'mini.pick'
local extra = require 'mini.extra'

extra.setup()

-- Custom `source.show`: mini's default colours only the leading file icon and
-- the live query matches. For location lists (LSP references, grep) also
-- treesitter-highlight the code snippet after the `path│lnum│col│` prefix. Only
-- the visible slice is ever passed here, so the cost is bounded by window height.
local hl_ns = vim.api.nvim_create_namespace 'MiniPickCodeHighlight'
local SEP = '│' -- rendered separator; mini stores it as a NUL byte internally
local SEP_LEN = #SEP

-- 0-based byte columns of the first three separators in a rendered line.
local function sep_cols(line)
  local cols, init = {}, 1
  for _ = 1, 3 do
    local i = line:find(SEP, init, true)
    if i == nil then break end
    cols[#cols + 1] = i - 1
    init = i + SEP_LEN
  end
  return cols
end

local function item_path(item)
  if type(item) == 'table' then return item.path end
  if type(item) == 'string' then return (item:match '^(.-)%z') end
end

-- mini.extra sets `hl` only on LSP symbol items, which carry their own kind
-- highlighting; everything else is a location list. Symbols also set `path`, so
-- that field cannot tell the two apart.
local function is_symbol_list(items) return type(items[1]) == 'table' and items[1].hl ~= nil end

local function treesitter_highlight(buf_id, row, col, code, ft)
  if code == '' or ft == nil then return end
  local lang = vim.treesitter.language.get_lang(ft)
  if lang == nil then return end
  local ok, parser = pcall(vim.treesitter.get_string_parser, code, lang)
  if not ok or parser == nil then return end
  local tree = (parser:parse() or {})[1]
  if tree == nil then return end
  local query = vim.treesitter.query.get(lang, 'highlights')
  if query == nil then return end
  for id, node in query:iter_captures(tree:root(), code, 0, -1) do
    local name = query.captures[id]
    if name:sub(1, 1) ~= '_' then
      local _, cs, _, ce = node:range()
      pcall(vim.api.nvim_buf_set_extmark, buf_id, hl_ns, row, col + cs, {
        end_row = row,
        end_col = col + ce,
        hl_group = '@' .. name .. '.' .. lang,
        priority = 150,
      })
    end
  end
end

local function show(buf_id, items, query)
  vim.api.nvim_buf_clear_namespace(buf_id, hl_ns, 0, -1)

  -- Mirror mini's own symbol rendering: no path icon, kind highlight from
  -- `text_start_col` onwards at priority 199 (just under the query matches).
  if is_symbol_list(items) then
    pick.default_show(buf_id, items, query)
    for i, item in ipairs(items) do
      if item.hl ~= nil then
        vim.api.nvim_buf_set_extmark(buf_id, hl_ns, i - 1, item.text_start_col or 0, {
          end_row = i,
          end_col = 0,
          hl_group = item.hl,
          priority = 199,
        })
      end
    end
    return
  end

  pick.default_show(buf_id, items, query, { show_icons = true })

  local lines = vim.api.nvim_buf_get_lines(buf_id, 0, -1, false)
  for i, item in ipairs(items) do
    local line = lines[i]
    local cols = line and sep_cols(line)
    if cols and #cols == 3 then
      -- Leave the `path│lnum│col│` prefix in its default colours.
      local code_col = cols[3] + SEP_LEN
      local ft = vim.filetype.match { filename = item_path(item) or '' }
      treesitter_highlight(buf_id, i - 1, code_col, line:sub(code_col + 1), ft)
    end
  end
end

pick.setup {
  source = { show = show },
  window = {
    -- Full editor width so grep snippets aren't truncated. Callable so it
    -- adapts to tmux pane resizes.
    config = function() return { width = vim.o.columns } end,
  },
}

-- rg skips symlinks unless asked, so a tree stitched together from them (a
-- dotfiles `.config` directory, say) comes back completely empty. Wanted by
-- every picker, hence the base list. One flag per element, so these double as
-- rg config-file bodies.
local RG_BASE = { '--follow' }

-- Dotfile-inclusive variants add `--hidden`, which only lifts the dotfile
-- filter: `.gitignore` still excludes `node_modules` and friends, while `.git`
-- needs the glob because it is not itself gitignored.
local RG_HIDDEN = vim.list_extend({ '--hidden', '--glob=!.git/' }, RG_BASE)

local has_rg = vim.fn.executable 'rg' == 1

-- Say so on every use: silently returning a partial result is the one outcome
-- that looks like the picker worked.
local function no_rg_fallback(picker)
  vim.notify('Needs `rg` to follow symlinks and include hidden files. Falling back to the built-in picker.', vim.log.levels.WARN)
  return picker()
end

local function rg_files(flags, name)
  if not has_rg then return no_rg_fallback(pick.builtin.files) end
  local command = vim.list_extend({ 'rg', '--files', '--color=never' }, flags)
  return pick.builtin.cli({ command = command }, { source = { name = name } })
end

local function rg_grep_live(flags, name)
  if not has_rg then return no_rg_fallback(pick.builtin.grep_live) end

  -- `grep_live` rebuilds its command every keystroke, leaving rg's own config
  -- file as the only way in. `MiniPick.start` blocks until the picker stops, so
  -- the override never outlives it and one scratch file serves every variant.
  local path = vim.fs.joinpath(vim.fn.stdpath 'cache', 'mini-pick-rg.conf')
  vim.fn.writefile(flags, path)
  local cached = vim.env.RIPGREP_CONFIG_PATH
  vim.env.RIPGREP_CONFIG_PATH = path
  local ok, err = pcall(pick.builtin.grep_live, { tool = 'rg' }, { source = { name = name } })
  vim.env.RIPGREP_CONFIG_PATH = cached
  if not ok then error(err) end
end

local function files() return rg_files(RG_BASE, 'Files (rg)') end
local function files_hidden() return rg_files(RG_HIDDEN, 'Files (rg, hidden)') end
local function grep_live() return rg_grep_live(RG_BASE, 'Grep live (rg)') end
local function grep_live_hidden() return rg_grep_live(RG_HIDDEN, 'Grep live (rg, hidden)') end

vim.keymap.set('n', '<leader>sh', pick.builtin.help, { desc = 'Help' })
vim.keymap.set('n', '<leader>sk', extra.pickers.keymaps, { desc = 'Keymaps' })
vim.keymap.set('n', '<leader>sf', files, { desc = 'Files' })
vim.keymap.set('n', '<leader>sF', files_hidden, { desc = 'Files (incl. hidden)' })
vim.keymap.set('n', '<leader>sg', grep_live, { desc = 'Grep' })
vim.keymap.set('n', '<leader>sG', grep_live_hidden, { desc = 'Grep (incl. hidden)' })
vim.keymap.set('n', '<leader>sd', extra.pickers.diagnostic, { desc = 'Diagnostics' })
vim.keymap.set('n', '<leader>sr', pick.builtin.resume, { desc = 'Resume' })
vim.keymap.set('n', '<leader>s.', function() extra.pickers.oldfiles { current_dir = true } end, { desc = 'Recent files' })
vim.keymap.set('n', '<leader>sb', pick.builtin.buffers, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>/', function() extra.pickers.buf_lines { scope = 'current' } end, { desc = 'Buffer lines' })
vim.keymap.set('n', '<leader>s/', function() extra.pickers.buf_lines { scope = 'all' } end, { desc = 'Lines in open files' })
