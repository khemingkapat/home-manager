local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.shiftwidth = 4


opt.syntax = "ON"

-- opt.clipboard = "unnamedplus"
vim.g.clipboard = {
  name = "WslClipboard",
  copy = {
    ["+"] = 'clip.exe',
    ["*"] = 'clip.exe',
  },
  paste = {
    ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
  },
  cache_enable = true,
}

opt.autoindent = true
opt.smartindent = true
opt.smartcase = true
opt.cursorline = true

opt.undofile = true
