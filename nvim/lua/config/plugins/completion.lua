return {
  {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = 'rafamadriz/friendly-snippets',

    -- use a release tag to download pre-built binaries
    version = '*',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'default',
        ['<C-j>'] = { 'select_next', 'fallback' },
        ['<C-k>'] = { 'select_prev', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' }
      },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono'
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
      completion = {
        accept = {
          auto_brackets = {
            enabled = true
          }
        },
        ghost_text = {
          enabled = true
        },
        menu = {
          auto_show = function(ctx)
            return ctx.mode ~= 'cmdline'
          end
        },
      }
    },
    opts_extend = { "sources.default" }
  }
}
