return {
    {
        "mfussenegger/nvim-dap",
        config = function()
            local dap = require 'dap'
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserDapConfig', {}),
                callback = function(ev)
                    local b = ev.buf

                    vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint,
                        { buffer = b, desc = "Toggle breakpoint [nvim-dap]" })
                    vim.keymap.set('n', '<leader>dc', dap.toggle_breakpoint,
                        { buffer = b, desc = "Continue execution [nvim-dap]" })
                    vim.keymap.set('n', '<leader>do', dap.step_over, { buffer = b, desc = "Step over [nvim-dap]" })
                    vim.keymap.set('n', '<leader>di', dap.step_into, { buffer = b, desc = "Step into [nvim-dap]" })
                end
            })
        end
    },

    {
        "rcarriga/nvim-dap-ui",
        config = function()
            local dapui = require 'dapui'
            dapui.setup()

            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserDapUiConfig', {}),
                callback = function(ev)
                    local b = ev.buf
                    vim.keymap.set('n', '<leader>du', dapui.toggle, { buffer = b, desc = "Open ui [nvim-dap-ui]" })
                end
            })
        end
    },

    {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
    },

    {
        "jay-babu/mason-nvim-dap.nvim",
        dependencies = {
            "williamboman/mason.nvim"
        },
        opts = {},
    },
}
