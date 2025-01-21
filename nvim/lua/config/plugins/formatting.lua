return {
  {
    "nvimtools/none-ls.nvim",
    config = function()
      local null_ls = require("null-ls")
      local fmt = null_ls.builtins.formatting
      null_ls.setup({
        sources = {
          fmt.nixpkgs_fmt,
          fmt.black,
          fmt.pg_format
        }
      })

      -- formatting keymap
      vim.keymap.set("n", "<space>fm", function()
        print("formatted")
        vim.lsp.buf.format()
      end)
      --
      --
      --
      -- format on save
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then
            return
          end

          ---@diagnostic disable-next-line: missing-parameter
          if client.supports_method('textDocument/formatting') then
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
                print("formatted")
              end,
            })
          end
        end,
      })
    end,
    requires = { "nvim-lua/plenary.nvim" }
  }
}
