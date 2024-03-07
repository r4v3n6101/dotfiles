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

    {
        "folke/trouble.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require 'trouble'.setup()

            -- Quickfix and loclist
            vim.keymap.set('n', 'gq', '<cmd>TroubleToggle quickfix<cr>',
                { desc = "Show quickfix [trouble.nvim]" })
            vim.keymap.set('n', 'gl', '<cmd>TroubleToggle loclist<cr>',
                { desc = "Show loclist [trouble.nvim]" })

            -- Lsp specific keybinds
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('TroubleLspConfig', {}),
                callback = function(ev)
                    local b = ev.buf

                    -- Diagnostics
                    vim.keymap.set('n', 'gqw', '<cmd>TroubleToggle workspace_diagnostics<cr>',
                        { buffer = b, desc = "Show workspace diagnostics [trouble.nvim]" })
                    vim.keymap.set('n', 'gqd', '<cmd>TroubleToggle document_diagnostics<cr>',
                        { buffer = b, desc = "Show document diagnostic [trouble.nvim]" })

                    -- This should rebind default lsp qfix list
                    vim.keymap.set('n', 'gd', '<cmd>TroubleToggle lsp_definitions<cr>',
                        { buffer = b, desc = "Show definitions [trouble.nvim]" })
                    vim.keymap.set('n', 'gr', '<cmd>TroubleToggle lsp_references<cr>',
                        { buffer = b, desc = "Show references [trouble.nvim]" })
                end
            })
        end
    },
}
