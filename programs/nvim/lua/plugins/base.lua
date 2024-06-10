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
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons"
        },
        keys = {
            { "<C-n>", "<cmd>NvimTreeToggle<cr>", desc = "Open filetree [nvim-tree.lua]" },
        },
        opts = {},
    },

    {
        "stevearc/oil.nvim",
        opts = {
            delete_to_trash = true,
        },
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        opts = {}
    },

    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {},
    },

    {
        "folke/trouble.nvim",
        config = true,
    }
}
