return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function()
      local actions = require("telescope.actions")
      require('telescope').setup({
        pickers = {
          find_files = {
            layout_strategy = "bottom_pane",
            layout_config = {
              height = 0.4,
            },
          },
          help_tags = { theme = "ivy" },
        },
      })

      local tsb = require('telescope.builtin')
      vim.keymap.set("n", "<space>ff", tsb.find_files)
      vim.keymap.set("n", "<space>fh", tsb.help_tags)

      require("config.telescope.multigrep").setup()
    end
  }
}
