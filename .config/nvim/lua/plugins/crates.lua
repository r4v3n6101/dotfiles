local function show_documentation(crates)
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

return {
    'saecki/crates.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'hrsh7th/nvim-cmp' },
    event = "BufReadPre Cargo.toml",
    config = function()
        local crates = require('crates')
        crates.setup()

        local kmap = vim.keymap.set
        local function opts(desc)
            return { desc = desc, silent = true }
        end

        kmap('n', '<leader>cu', crates.update_crate, opts("update crate [crates.nvim]"))
        kmap('v', '<leader>cu', crates.update_crates, opts("update crates (visual) [crates.nvim]"))
        kmap('n', '<leader>ca', crates.update_all_crates, opts("update all crates [crates.nvim]"))
        kmap('n', '<leader>cU', crates.upgrade_crate, opts("upgrade crate [crates.nvim]"))
        kmap('v', '<leader>cU', crates.upgrade_crates, opts("upgrade crates (visual) [crates.nvim]"))
        kmap('n', '<leader>cA', crates.upgrade_all_crates, opts("upgrade all crates [crates.nvim]"))
        kmap('n', '<leader>cH', crates.open_homepage, opts("open homepage [crates.nvim]"))
        kmap('n', '<leader>cR', crates.open_repository, opts("open repository [crates.nvim]"))
        kmap('n', '<leader>cD', crates.open_documentation, opts("open documentation [crates.nvim]"))
        kmap('n', '<leader>cC', crates.open_crates_io, opts("open crates.io [crates.nvim]"))


        kmap('n', 'K', function() show_documentation(crates) end, { noremap = true, silent = true })

        -- Optional complete extension
        local status, cmp = pcall(require, "cmp")
        if (status) then
            vim.api.nvim_create_autocmd("BufReadPre", {
                group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
                pattern = "Cargo.toml",
                callback = function()
                    cmp.setup.buffer({ sources = { { name = "crates" } } })
                end,
            })
        end
    end
}
