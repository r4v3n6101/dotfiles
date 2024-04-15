return {
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
    }
}
