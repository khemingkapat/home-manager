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
      lsp.clangd.setup(opts)
      lsp.postgres_lsp.setup(opts)
      lsp.asm_lsp.setup(opts)
      lsp.gopls.setup(opts)
      lsp.ts_ls.setup(opts)
      lsp.julials.setup({
        cmd = {
          "julia",
          "--project=@.", -- use the local Julia environment
          "--startup-file=no",
          "--history-file=no",
          "-e",
          [[
            using LanguageServer, SymbolServer;
            depot_path = get(ENV, "JULIA_DEPOT_PATH", "");
            project_path = dirname(something(Base.current_project(pwd()), Base.active_project()));
            server = LanguageServer.LanguageServerInstance(stdin, stdout, project_path, depot_path);
            server.runlinter = true;
            run(server);
          ]],
        },
        filetypes = { "julia" },
        root_dir = lsp.util.root_pattern("Project.toml", ".git"),
        capabilities = capabilities,
      })

      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<space>gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<space>gr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, {})
      vim.keymap.set("n", "<space>em", vim.diagnostic.open_float, {})
    end,
  }
}
