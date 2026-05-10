-- Autocompletion powered by blink.cmp

require('luasnip').setup {}

---@module 'blink.cmp'
---@type blink.cmp.Config
require('blink.cmp').setup {
  keymap = { preset = 'default' },
  appearance = { nerd_font_variant = 'mono' },
  completion = {
    documentation = {
      auto_show = false,
      auto_show_delay_ms = 500,
    },
  },

  sources = {
    default = { 'lsp', 'path', 'snippets' },
  },

  snippets = { preset = 'luasnip' },
  fuzzy = { implementation = 'prefer_rust_with_warning' },
  signature = { enabled = true },
}
