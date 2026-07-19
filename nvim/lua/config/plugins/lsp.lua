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

      local servers = {
        "lua_ls", "nil_ls", "pyright", "clangd",
        "postgres_lsp", "asm_lsp", "gopls", "ts_ls"
      }

      for _, server in ipairs(servers) do
        vim.lsp.config(server, { capabilities = capabilities })
        vim.lsp.enable(server)
      end

      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<space>gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<space>gr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, {})
      vim.keymap.set("n", "<space>em", vim.diagnostic.open_float, {})
    end,
  }
}
