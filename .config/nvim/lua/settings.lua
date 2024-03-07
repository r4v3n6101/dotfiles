vim.g.mapleader = " "

-- Main settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'yes'
vim.opt.list = true
vim.opt.listchars = {
    tab = "▸ ",
    nbsp = "⍽",
    extends = "⟩",
    precedes = "⟨",
    trail = "-",
    space = ".",
    eol = "↲",
}
vim.opt.termguicolors = true
vim.opt.updatetime = 300
vim.opt.clipboard:append { 'unnamed', 'unnamedplus' }

-- Disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Tab settings
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true

-- Highlight after yank
vim.api.nvim_exec([[
augroup YankHighlight
autocmd!
autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=700}
augroup end
]], false)
