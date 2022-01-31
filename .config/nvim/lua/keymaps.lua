local cmd = vim.cmd
local map = vim.api.nvim_set_keymap
local default_opts = {noremap = true, silent = true}

map('n', 'K', [[ <cmd>lua vim.lsp.buf.hover()<CR> ]], default_opts)
map('n', 'gd', [[ <cmd>lua vim.lsp.buf.definition()<CR> ]], default_opts)
map('n', 'gi', [[ <cmd>lua vim.lsp.buf.implementation()<CR> ]], default_opts)
map('n', 'gr', [[ <cmd>lua vim.lsp.buf.references()<CR> ]], default_opts)
map('n', 'ga', [[ <cmd>lua vim.lsp.buf.code_action()<CR> ]], default_opts)
