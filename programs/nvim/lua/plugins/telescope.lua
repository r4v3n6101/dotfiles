return {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        "debugloop/telescope-undo.nvim",
    },
    keys = {
        { "<leader>ff", "<cmd>Telescope find_files<cr>",  desc = "Find files [telescope.nvim]" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>",   desc = "Find by grep [telescope.nvim]" },
        { "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Find by current word [telescope.nvim]" },
        { "<leader>fb", "<cmd>Telescope buffers<cr>",     desc = "Find in opened buffers [telescope.nvim]" },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>",   desc = "Find in help tags [telescope.nvim]" },
        { "<leader>fj", "<cmd>Telescope jumplist<cr>",    desc = "Find in jumplist [telescope.nvim]" },
        { "<leader>fr", "<cmd>Telescope registers<cr>",   desc = "Find in registers [telescope.nvim]" },
        { "<leader>fm", "<cmd>Telescope marks<cr>",       desc = "Find in marks [telescope.nvim]" },
        { "<leader>fu", "<cmd>Telescope undo<cr>",        desc = "Find in undo tree [telescope.nvim]" },
    },
    config = function()
        require("telescope").setup({
            extensions = {
                undo = {},
            },
        })
        require("telescope").load_extension("undo")
    end
}
