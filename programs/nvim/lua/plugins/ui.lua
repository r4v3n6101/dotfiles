return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme catppuccin-frappe]])
        end
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {}
    },
}
