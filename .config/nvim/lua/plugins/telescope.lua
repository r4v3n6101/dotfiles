return {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    config = function()
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "find files [telescope.nvim]" })
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "find by grep [telescope.nvim]" })
        vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "find in buffers [telescope.nvim]" })
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "find in help tags [telescope.nvim]" })
    end
}
