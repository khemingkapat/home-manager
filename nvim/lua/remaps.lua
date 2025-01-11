-- small terminal
vim.keymap.set("n", "<space>st", function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 7)
end)

vim.keymap.set("t", "<esc><esc>", function()
  vim.api.nvim_win_close(0, true)
end)

vim.keymap.set({ "n", "t" }, "<space>tt", ":FloatTerminal<CR>")
