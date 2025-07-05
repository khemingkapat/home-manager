local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.shiftwidth = 4


opt.syntax = "ON"

-- opt.clipboard = "unnamedplus"
vim.g.clipboard = {
  name = "wl-clipboard",
  copy = {
    ["+"] = "wl-copy",
    ["*"] = "wl-copy",
  },
  paste = {
    ["+"] = 'wl-paste --no-newline',
    ["*"] = 'wl-paste --no-newline',
  },
  cache_enable = true,
}

opt.autoindent = true
opt.smartindent = true
opt.smartcase = true
opt.cursorline = true

opt.undofile = true
