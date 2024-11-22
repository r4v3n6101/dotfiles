return {
    {
        'mfussenegger/nvim-dap',
        keys = {
            { "<F5>", "<cmd>DapToggleBreakpoint<cr>", desc = "Toggle breakpoint [nvim-dap]" },
            { "<F1>", "<cmd>DapContinue<cr>",         desc = "Continue or start execution [nvim-dap]" },
            { "<F2>", "<cmd>DapStepInto<cr>",         desc = "Step into [nvim-dap]" },
            { "<F3>", "<cmd>DapStepOut<cr>",          desc = "Step out [nvim-dap]" },
            { "<F4>", "<cmd>DapStepOver<cr>",         desc = "Step over [nvim-dap]" }
        }
    }
}
