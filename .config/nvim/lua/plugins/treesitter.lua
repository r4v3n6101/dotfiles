require('nvim-treesitter.configs').setup({
    ensure_installed = {'rust', 'lua'},
    highlight = {enable = true},
    indent = {enable = true}
})
