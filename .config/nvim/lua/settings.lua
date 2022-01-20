local g = vim.g
local opt = vim.opt
local cmd = vim.cmd
local exec = vim.api.nvim_exec


-- Main settings
opt.number = true
opt.signcolumn = 'yes'
opt.list = true
opt.listchars = {
  tab = "▸ ",
  nbsp = "⍽",
  extends = "⟩",
  precedes = "⟨",
  trail = "-",
  space = ".",
  eol = "↲",
}

-- Tab settings
cmd([[
filetype indent plugin on
syntax enable
]])
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.smartindent = true

-- Highlight after yank
exec([[
augroup YankHighlight
autocmd!
autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=700}
augroup end
]], false)
