return {
    'jacoborus/tender.vim',
    config = function()
        vim.opt.termguicolors = true
        vim.cmd([[colorscheme tender]])
    end
}
