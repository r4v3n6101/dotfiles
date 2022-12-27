local function cfg()
    local builtin = require('telescope.builtin')
    local kmap = vim.keymap.set
    
    kmap('n', '<leader>ff', builtin.find_files, {})
    kmap('n', '<leader>fg', builtin.live_grep, {})
    kmap('n', '<leader>fb', builtin.buffers, {})
    kmap('n', '<leader>fh', builtin.help_tags, {})
end

return {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    config = cfg,
}
