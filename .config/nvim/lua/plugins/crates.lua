return {
    'Saecki/crates.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = "BufReadPre Cargo.toml",
    config = function()
        local crates = require 'crates'
        crates.setup()

        local bufnr = vim.api.nvim_get_current_buf()

        vim.keymap.setup('n', "<leader>cu", crates.update_crate,
            { buffer = bufnr, silent = true, desc = "Update crate [crates.nvim]" })
        vim.keymap.setup('n', "<leader>cu", crates.update_crate,
            { buffer = bufnr, silent = true, desc = "Update crate [crates.nvim]" })
        vim.keymap.setup('v', "<leader>cu", crates.update_crates,
            { buffer = bufnr, silent = true, desc = "Update crates (visual) [crates.nvim]" })
        vim.keymap.setup('n', "<leader>ca", crates.update_all_crates,
            { buffer = bufnr, silent = true, desc = "Update all crates [crates.nvim]" })
        vim.keymap.setup('n', "<leader>cU", crates.upgrade_crate,
            { buffer = bufnr, silent = true, desc = "Upgrade crate [crates.nvim]" })
        vim.keymap.setup('v', "<leader>cU", crates.upgrade_crates,
            { buffer = bufnr, silent = true, desc = "Upgrade crates (visual) [crates.nvim]" })
        vim.keymap.setup('n', "<leader>cA", crates.upgrade_all_crates,
            { buffer = bufnr, silent = true, desc = "Upgrade all crates [crates.nvim]" })
        vim.keymap.setup('n', "<leader>cH", crates.open_homepage,
            { buffer = bufnr, silent = true, desc = "Open homepage [crates.nvim]" })
        vim.keymap.setup('n', "<leader>cR", crates.open_repository,
            { buffer = bufnr, silent = true, desc = "Open repository [crates.nvim]" })
        vim.keymap.setup('n', "<leader>cD", crates.open_documentation,
            { buffer = bufnr, silent = true, desc = "Open documentation [crates.nvim]" })
        vim.keymap.setup('n', "<leader>cC", crates.open_crates_io,
            { buffer = bufnr, silent = true, desc = "Open crates.io [crates.nvim]" })
    end
}
