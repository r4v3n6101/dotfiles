return {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        "debugloop/telescope-undo.nvim",
    },
    keys = {
        { "<leader>ff", "<cmd>Telescope find_files<cr>",                    desc = "Find files [telescope.nvim]" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>",                     desc = "Find by grep [telescope.nvim]" },
        { "<leader>fb", "<cmd>Telescope buffers initial_mode=normal<cr>",   desc = "Find in opened buffers [telescope.nvim]" },
        { "<leader>fh", "<cmd>Telescope help_tags initial_mode=normal<cr>", desc = "Find in help tags [telescope.nvim]" },
        { "<leader>fj", "<cmd>Telescope jumplist initial_mode=normal<cr>",  desc = "Find in jumplist [telescope.nvim]" },
        { "<leader>fr", "<cmd>Telescope registers initial_mode=normal<cr>", desc = "Find in registers [telescope.nvim]" },
        { "<leader>fm", "<cmd>Telescope marks initial_mode=normal<cr>",     desc = "Find in marks [telescope.nvim]" },
        { "<leader>fu", "<cmd>Telescope undo initial_mode=normal<cr>",      desc = "Find in undo tree [telescope.nvim]" },
    },
    config = function()
        local mappings = {
            ["<C-q>"] = function(prompt_bufnr)
                require("trouble.sources.telescope").open(prompt_bufnr, { focus = true })
            end,
            ["<M-q>"] = function(prompt_bufnr)
                require("trouble.sources.telescope").open(prompt_bufnr, { focus = true })
            end
        };
        require("telescope").setup({
            defaults = {
                mappings = {
                    i = mappings,
                    n = mappings,
                },
            },
            extensions = {
                undo = {},
            },
        })
        require("telescope").load_extension("undo")
    end
}
