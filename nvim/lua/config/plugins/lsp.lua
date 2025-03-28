-- install the language server through nix-env, might consider do it with mason
--
--
return {
  {
    "neovim/nvim-lspconfig",

    -- stole form lazydev.nvim providing lua lsp for vim
    dependencies = {
      "folke/lazydev.nvim",
      ft = "lua", -- only load on lua files
      opts = {
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },


    config = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      local lsp = require("lspconfig")

      local opts = { capabilities = capabilities }

      lsp.lua_ls.setup(opts)
      lsp.nil_ls.setup(opts)
      lsp.pyright.setup(opts)
      lsp.ccls.setup(opts)
      lsp.postgres_lsp.setup(opts)
      lsp.asm_lsp.setup(opts)
      lsp.gopls.setup(opts)
      --
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<space>gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<space>gr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, {})
      vim.keymap.set("n", "<space>em", vim.diagnostic.open_float, {})
    end,
  }
}
