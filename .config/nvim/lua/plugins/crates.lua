local crates = require('crates')
crates.setup()

local opts = { noremap = true, silent = true }
local kmap = vim.keymap.set

kmap('n', '<leader>cu', crates.update_crate, opts)
kmap('v', '<leader>cu', crates.update_crates, opts)
kmap('n', '<leader>ca', crates.update_all_crates, opts)
kmap('n', '<leader>cU', crates.upgrade_crate, opts)
kmap('v', '<leader>cU', crates.upgrade_crates, opts)
kmap('n', '<leader>cA', crates.upgrade_all_crates, opts)

kmap('n', '<leader>cH', crates.open_homepage, opts)
kmap('n', '<leader>cR', crates.open_repository, opts)
kmap('n', '<leader>cD', crates.open_documentation, opts)
kmap('n', '<leader>cC', crates.open_crates_io, opts)

local function show_documentation()
    local filetype = vim.bo.filetype
    if vim.tbl_contains({ 'vim', 'help' }, filetype) then
        vim.cmd('h ' .. vim.fn.expand('<cword>'))
    elseif vim.tbl_contains({ 'man' }, filetype) then
        vim.cmd('Man ' .. vim.fn.expand('<cword>'))
    elseif vim.fn.expand('%:t') == 'Cargo.toml' and crates.popup_available() then
        crates.show_popup()
    else
        vim.lsp.buf.hover()
    end
end

kmap('n', 'K', show_documentation, opts)

-- Optional complete extension
local status, cmp = pcall(require, "cmp")
if (status) then
    vim.api.nvim_create_autocmd("BufRead", {
        group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
        pattern = "Cargo.toml",
        callback = function()
            cmp.setup.buffer({ sources = { { name = "crates" } } })
        end,
    })
end
