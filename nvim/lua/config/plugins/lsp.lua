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
      local util = require('lspconfig.util')


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
        capabilities = capabilities,
        on_new_config = function(new_config, new_root_dir)
          -- This tells Julia to use the project folder as the environment
          -- but still allows it to find LanguageServer in your global env
          new_config.cmd = {
            "julia",
            "--project=" .. new_root_dir,
            "--startup-file=no",
            "--history-file=no",
            "-e",
            "using LanguageServer; runserver()",
          }
        end,
        root_dir = function(fname)
          -- This looks for Project.toml or Manifest.toml to find the project root
          return util.root_pattern("Project.toml", "Manifest.toml", ".git")(fname) or vim.fn.getcwd()
        end,
      })
      -- lsp.julials.setup({
      --   on_new_config = function(new_config, new_root_dir)
      --     -- This ensures Julia uses the specific project directory as the environment
      --     new_config.cmd = {
      --       "julia",
      --       "--project=" .. new_root_dir,
      --       "--startup-file=no",
      --       "--history-file=no",
      --       "-e",
      --       [[
      --   using LanguageServer;
      --   depot_path = get(ENV, "JULIA_DEPOT_PATH", "");
      --   project_path = "]] .. new_root_dir .. [[";
      --   server = LanguageServer.LanguageServerInstance(stdin, stdout, project_path, depot_path);
      --   server.runlinter = true;
      --   run(server);
      -- ]]
      --     }
      --   end,
      --   root_dir = function(fname)
      --     local root = util.root_pattern("Project.toml", "Manifest.toml", ".git")(fname)
      --     return root or vim.fn.getcwd()
      --   end,
      --
      --   filetypes = { "julia" },
      --   capabilities = capabilities,
      -- })

      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "<space>gd", vim.lsp.buf.definition, {})
      vim.keymap.set("n", "<space>gr", vim.lsp.buf.references, {})
      vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, {})
      vim.keymap.set("n", "<space>em", vim.diagnostic.open_float, {})
    end,
  }
}
