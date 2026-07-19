return {
  {
    "nvimtools/none-ls.nvim",
    config = function()
      local null_ls = require("null-ls")
      local fmt = null_ls.builtins.formatting
      -- local diag = null_ls.builtins.diagnostics
      null_ls.setup({
        sources = {
          fmt.nixpkgs_fmt,
          fmt.black,
          fmt.pg_format,
          fmt.asmfmt,
          fmt.gofumpt,
          fmt.prettier,
        }
      })

      -- formatting keymap
      vim.keymap.set("n", "<space>fm", function()
        local bufnr = vim.api.nvim_get_current_buf()
        -- get all attached clients that support formatting
        local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
        local fmt_clients = {}

        for _, client in ipairs(clients) do
          if client.supports_method("textDocument/formatting") then
            table.insert(fmt_clients, client.name)
          end
        end

        if #fmt_clients == 0 then
          print("No formatter attached")
          return
        end

        -- do the formatting
        vim.lsp.buf.format({ bufnr = bufnr, async = true })

        -- print the formatters used
        print("Formatted by: " .. table.concat(fmt_clients, ", "))
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
