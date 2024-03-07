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
        local crates = require 'crates'
        crates.setup()

        vim.keymap.setup('n', "<leader>cu", crates.update_crate,
            { desc = "Update crate [crates.nvim]", silent = true })
        vim.keymap.setup('n', "<leader>cu", crates.update_crate,
            { desc = "Update crate [crates.nvim]", silent = true })
        vim.keymap.setup('v', "<leader>cu", crates.update_crates,
            { desc = "Update crates (visual) [crates.nvim]", silent = true })
        vim.keymap.setup('n', "<leader>ca", crates.update_all_crates,
            { desc = "Update all crates [crates.nvim]", silent = true })
        vim.keymap.setup('n', "<leader>cU", crates.upgrade_crate,
            { desc = "Upgrade crate [crates.nvim]", silent = true })
        vim.keymap.setup('v', "<leader>cU", crates.upgrade_crates,
            { desc = "Upgrade crates (visual) [crates.nvim]", silent = true })
        vim.keymap.setup('n', "<leader>cA", crates.upgrade_all_crates,
            { desc = "Upgrade all crates [crates.nvim]", silent = true })
        vim.keymap.setup('n', "<leader>cH", crates.open_homepage,
            { desc = "Open homepage [crates.nvim]", silent = true })
        vim.keymap.setup('n', "<leader>cR", crates.open_repository,
            { desc = "Open repository [crates.nvim]", silent = true })
        vim.keymap.setup('n', "<leader>cD", crates.open_documentation,
            { desc = "Open documentation [crates.nvim]", silent = true })
        vim.keymap.setup('n', "<leader>cC", crates.open_crates_io,
            { desc = "Open crates.io [crates.nvim]", silent = true })
        vim.keymap.setup('n', 'K', function() show_documentation(crates) end,
            { noremap = true, silent = true })

        require 'cmp'.setup.buffer({ sources = { { name = "crates" } } })
    end
}
