return {
    "folke/sidekick.nvim",
    opts = {},
    keys = {
        {
            "<tab>",
            function()
                if not require("sidekick").nes_jump_or_apply() then
                    return "<Tab>"
                end
            end,
            expr = true,
            desc = "Goto/apply next edit suggestion [sidekick.nvim]",
        },
        {
            "<leader>as",
            function() require("sidekick.cli").select({ filter = { installed = true } }) end,
            desc = "Select CLI [sidekick.nvim]",
        },
        {
            "<leader>aa",
            function() require("sidekick.cli").toggle() end,
            desc = "Toggle CLI [sidekick.nvim]",
        },
        {
            "<leader>ad",
            function() require("sidekick.cli").close() end,
            desc = "Detach a CLI Session [sidekick.nvim]",
        },
        {
            "<leader>ap",
            function() require("sidekick.cli").prompt() end,
            mode = { "n", "x" },
            desc = "Select prompt [sidekick.nvim]",
        },
        {
            "<leader>at",
            function() require("sidekick.cli").send({ msg = "{this}" }) end,
            mode = { "x", "n" },
            desc = "Send @this [sidekick.nvim]",
        },
        {
            "<leader>af",
            function() require("sidekick.cli").send({ msg = "{file}" }) end,
            desc = "Send @file [sidekick.nvim]",
        },
        {
            "<leader>av",
            function() require("sidekick.cli").send({ msg = "{selection}" }) end,
            mode = { "x" },
            desc = "Send @selection [sidekick.nvim]",
        }
    }
}
