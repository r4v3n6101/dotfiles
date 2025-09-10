return {
    { 'nvim-telescope/telescope-dap.nvim' },
    { 'debugloop/telescope-undo.nvim' },
    {
        'nvim-telescope/telescope.nvim',
        dependencies = { 'nvim-lua/plenary.nvim' },
        keys = {
            { "<leader>fc", "<cmd>Telescope resume initial_mode=normal<cr>",      desc = "Continue last Telescope search [telescope.nvim]" },
            { "<leader>ff", "<cmd>Telescope find_files<cr>",                      desc = "Find files [telescope.nvim]" },
            { "<leader>fg", "<cmd>Telescope live_grep<cr>",                       desc = "Find by grep [telescope.nvim]" },
            { "<leader>fb", "<cmd>Telescope buffers initial_mode=normal<cr>",     desc = "Find in opened buffers [telescope.nvim]" },
            { "<leader>fh", "<cmd>Telescope help_tags initial_mode=normal<cr>",   desc = "Find in help tags [telescope.nvim]" },
            { "<leader>fj", "<cmd>Telescope jumplist initial_mode=normal<cr>",    desc = "Find in jumplist [telescope.nvim]" },
            { "<leader>fr", "<cmd>Telescope registers initial_mode=normal<cr>",   desc = "Find in registers [telescope.nvim]" },
            { "<leader>fm", "<cmd>Telescope marks initial_mode=normal<cr>",       desc = "Find in marks [telescope.nvim]" },
            { "<leader>fd", "<cmd>Telescope diagnostics sort_by=severity initial_mode=normal<cr>", desc = "Find in diagnostics [telescope.nvim]" },
            { "<leader>fu", "<cmd>Telescope undo initial_mode=normal<cr>",        desc = "Find in undo tree [telescope.nvim]" },
            { "<leader>df", "<cmd>Telescope dap frames initial_mode=normal<cr>",  desc = "Find in debug frames [telescope-dap.nvim]" },
        },
        config = function()
            require("telescope").setup({
                pickers = {
                    live_grep = {
                        file_ignore_patterns = { 'node_modules', '.git', '.venv' },
                        additional_args = function(_)
                            return { "--hidden" }
                        end
                    },
                    find_files = {
                        file_ignore_patterns = { 'node_modules', '.git', '.venv' },
                        hidden = true
                    }

                },
                extensions = {
                    undo = {},
                    dap = {},
                },
            })
            require("telescope").load_extension("undo")
            require("telescope").load_extension("dap")
        end
    }
}
