local function cfg()
    vim.opt.termguicolors = true
    vim.cmd([[colorscheme tender]])
end

return {
    'jacoborus/tender.vim',
    config = cfg
}
