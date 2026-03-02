return {
    {
        'nvim-mini/mini.extra',
        version = '*',
        opts = {}
    },
    {
        'nvim-mini/mini.pick',
        version = '*',
        opts = {},
        keys = {
            { "<leader>fc", "<cmd>Pick resume<cr>",     desc = "Continue last search [mini.pick]" },
            { "<leader>ff", "<cmd>Pick files<cr>",      desc = "Find files [mini.pick]" },
            { "<leader>fg", "<cmd>Pick grep_live<cr>",  desc = "Find by grep [mini.pick]" },
            { "<leader>fb", "<cmd>Pick buffers<cr>",    desc = "Find in opened buffers [mini.pick]" },
            { "<leader>fh", "<cmd>Pick help<cr>",       desc = "Find in help tags [mini.pick]" },
            { "<leader>fr", "<cmd>Pick registers<cr>",  desc = "Find in registers [mini.pick]" },
            { "<leader>fm", "<cmd>Pick marks<cr>",      desc = "Find in marks [mini.pick]" },
            { "<leader>fd", "<cmd>Pick diagnostic<cr>", desc = "Find in diagnostics [mini.pick]" },
            { "<leader>fk", "<cmd>Pick keymaps<cr>",    desc = "Find in keymaps [mini.pick]" },
            { "<leader>fo", "<cmd>Pick options<cr>",    desc = "Find in options [mini.pick]" },
        }
    },
}
