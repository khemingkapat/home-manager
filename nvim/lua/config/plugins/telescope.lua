return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function()
      require('telescope').setup({
        -- pickers = {
        --   find_files = { theme = "ivy" },
        --   help_tags = { theme = "ivy" },
        -- }
      })

      local tsb = require('telescope.builtin')

      vim.keymap.set("n", "<space>ff", tsb.find_files)
      vim.keymap.set("n", "<space>fh", tsb.help_tags)

      require("config.telescope.multigrep").setup()
    end
  }
}
