-- Mirrors the Ghostty theme; keep in sync with .config/ghostty/config.
require('modus-themes').setup {
  variants = {
    modus_vivendi = 'tinted',
  },
  -- Ghostty paints its window padding in the terminal background, so a gutter
  -- tinted differently from Normal leaves a stripe down the left edge.
  line_nr_column_background = false,
  sign_column_background = false,
  styles = {
    comments = { italic = true },
    -- italic is explicit: modus merges styles rather than replacing them.
    keywords = { bold = true, italic = false },
  },
  on_highlights = function(highlights, colors)
    -- CursorLineSign is Neovim's, not modus's, so patch rather than index.
    local function patch(group, attrs, base)
      highlights[group] = vim.tbl_extend('force', highlights[base or group] or {}, attrs)
    end

    -- `styles` has no types key.
    patch('Type', { italic = true, bold = true })

    -- Floats default to bg_active, which modus means for the mode line; bg_dim
    -- is the recessed panel shade. mini.pick and blink.cmp link here.
    for _, group in ipairs { 'NormalFloat', 'FloatBorder', 'FloatTitle', 'Pmenu' } do
      patch(group, { bg = colors.bg_dim })
    end

    -- Run bg_hl_line across the whole cursor line, gutter included.
    patch('CursorLineNr', { bg = colors.bg_hl_line })
    patch('CursorLineSign', { bg = colors.bg_hl_line }, 'SignColumn')
  end,
}

vim.cmd.colorscheme 'modus_vivendi'

-- Mirror Ghostty's palette so :terminal matches the surrounding terminal. The
-- plugin's own brights swap white and bright-white, and sink brblack to
-- #1d2235, which is indistinguishable from the background.
local ghostty_palette = {
  [0] = '#0d0e1c',
  [1] = '#ff5f59',
  [2] = '#44bc44',
  [3] = '#d0bc00',
  [4] = '#2fafff',
  [5] = '#feacd0',
  [6] = '#00d3d0',
  [7] = '#a6a6a6',
  [8] = '#595959',
  [9] = '#ff6b55',
  [10] = '#00c06f',
  [11] = '#fec43f',
  [12] = '#79a8ff',
  [13] = '#b6a0ff',
  [14] = '#6ae4b9',
  [15] = '#ffffff',
}

for slot, colour in pairs(ghostty_palette) do
  vim.g['terminal_color_' .. slot] = colour
end
