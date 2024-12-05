return {
    { "lambdalisue/suda.vim", },

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
        'nvim-treesitter/nvim-treesitter',
        config = function()
            require 'nvim-treesitter.configs'.setup {
                ensure_installed = { "c", "rust", "lua", "vim", "vimdoc", "markdown", "markdown_inline" },
                sync_install = false,
                auto_install = true,
                ignore_install = { "javascript" },
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
    }
}
