return {
    {
        'mfussenegger/nvim-dap',
        keys = {
            { "<leader>db", "<cmd>DapToggleBreakpoint<cr>", desc = "Toggle breakpoint [nvim-dap]" },
            { "<leader>dc", "<cmd>DapContinue<cr>",         desc = "Continue or start execution [nvim-dap]" },
            { "<leader>di", "<cmd>DapStepInto<cr>",         desc = "Step into [nvim-dap]" },
            { "<leader>do", "<cmd>DapStepOut<cr>",          desc = "Step out [nvim-dap]" },
            { "<leader>dn", "<cmd>DapStepOver<cr>",         desc = "Step over (go to next) [nvim-dap]" }
        }
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap",
            "nvim-neotest/nvim-nio"
        },
        config = function()
            require("dapui").setup()
            vim.keymap.set('n', "<leader>du", require 'dapui'.toggle, { desc = "Open DAP UI [nvim-dap-ui]" });
        end
    }
}
