return {
    {
        "lambdalisue/suda.vim"
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
        "stevearc/oil.nvim",
        config = function()
            require 'oil'.setup({
                delete_to_trash = true,
                default_file_explorer = true,
            })

            vim.keymap.set('n', '<leader>n', require 'oil'.toggle_float, { desc = "Open oil float view [oil.nvim]", })
        end
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
        'stevearc/quicker.nvim',
        event = "FileType qf",
        config = function()
            require("quicker").setup({
                highlight = {
                    lsp = false,
                    treesitter = true,
                    load_buffers = true,
                },
                edit = {
                    enabled = false,
                },
                constrain_cursor = true,
                keys = {
                    {
                        ">",
                        function()
                            require 'quicker'.expand({ before = 2, after = 2, add_to_existing = true })
                        end,
                        desc = "Expand quickfix context [quicker.nvim]",
                    },
                    {
                        "<",
                        function()
                            require 'quicker'.collapse()
                        end,
                        desc = "Collapse quickfix context [quicker.nvim]",
                    },
                },
            })
        end
    },
    {
        'kevinhwang91/nvim-bqf',
        event = "FileType qf",
        opts = {
            preview = {
                winblend = 0
            }
        }
    },
    {
        'nvim-treesitter/nvim-treesitter',
        config = function()
            require 'nvim-treesitter.configs'.setup {
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    disable = { "rust" },
                },
                indent = {
                    enable = true
                }
            }
            vim.wo.foldmethod = 'expr'
            vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            vim.wo.foldlevel = 99
        end
    },
    {
        'nvim-treesitter/nvim-treesitter-context',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        config = function()
            require 'treesitter-context'.setup {
                max_lines = 3,
            }
            vim.keymap.set("n", "[c", function() require("treesitter-context").go_to_context(vim.v.count1) end,
                { silent = true, desc = "Go to context (upwards) [nvim-treesitter-context]" })
        end
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        opts = {
            no_italic = true,
            term_colors = true,
            transparent_background = false,
            styles = {
                comments = {},
                conditionals = {},
                loops = {},
                functions = {},
                keywords = {},
                strings = {},
                variables = {},
                numbers = {},
                booleans = {},
                properties = {},
                types = {},
            },
            color_overrides = {
                mocha = {
                    base = "#000000",
                    mantle = "#000000",
                    crust = "#000000",
                },
            },
        },
        init = function()
            vim.cmd([[colorscheme catppuccin]])
        end
    },
    {
        "nvim-tree/nvim-web-devicons",
        opts = {}
    },
}
