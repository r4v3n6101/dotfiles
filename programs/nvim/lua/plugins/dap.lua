return {
    'mfussenegger/nvim-dap',
    dependencies = {
        {
            'igorlfs/nvim-dap-view',
            keys = {
                { "<leader>du", "<cmd>DapViewToggle<cr>", desc = "Open debug ui [nvim-dap-view]" },
                { "<leader>dw", "<cmd>DapViewWatch<cr>",  desc = "Add expression [nvim-dap-view]" }
            },
            config = function()
                local dap, dv = require("dap"), require("dap-view")

                dap.defaults.fallback.switchbuf = "useopen"
                dap.listeners.before.attach["dap-view-config"] = function()
                    dv.open()
                end
                dap.listeners.before.launch["dap-view-config"] = function()
                    dv.open()
                end
                dap.listeners.before.event_terminated["dap-view-config"] = function()
                    dv.close()
                end
                dap.listeners.before.event_exited["dap-view-config"] = function()
                    dv.close()
                end
            end
        },
        {
            'theHamsta/nvim-dap-virtual-text',
            config = function()
                require("nvim-dap-virtual-text").setup()
            end
        }
    },
    keys = {
        { "<leader>db", "<cmd>DapToggleBreakpoint<cr>", desc = "Toggle breakpoint [nvim-dap]" },
        { "<leader>dc", "<cmd>DapContinue<cr>",         desc = "Continue or start execution [nvim-dap]" },
        { "<leader>dn", "<cmd>DapStepOver<cr>",         desc = "Step over (go to next) [nvim-dap]" },
        { "<leader>di", "<cmd>DapStepInto<cr>",         desc = "Step into [nvim-dap]" },
        { "<leader>do", "<cmd>DapStepOut<cr>",          desc = "Step out [nvim-dap]" },
        {
            "<leader>ds",
            function()
                local widgets = require('dap.ui.widgets')
                widgets.centered_float(widgets.scopes)
            end,
            desc = "Open scope window [nvim-dap]"
        }
    }
}
