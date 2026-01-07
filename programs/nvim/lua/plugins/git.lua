return {
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            local gs = require('gitsigns')
            gs.setup {
                numhl = true,
                attach_to_untracked = true,
                on_attach = function(bufnr)
                    vim.keymap.set('n', ']h', function()
                        if vim.wo.diff then
                            vim.cmd.normal({ ']h', bang = true })
                        else
                            gs.nav_hunk('next')
                        end
                    end, { buffer = bufnr, desc = "Next hunk [gitsigns.nvim]" })

                    vim.keymap.set('n', '[h', function()
                        if vim.wo.diff then
                            vim.cmd.normal({ '[h', bang = true })
                        else
                            gs.nav_hunk('prev')
                        end
                    end, { buffer = bufnr, desc = "Previous hunk [gitsigns.nvim]" })

                    vim.keymap.set('n', '<leader>hs', gs.stage_hunk,
                        { buffer = bufnr, desc = "Stage hunk [gitsigns.nvim]" })
                    vim.keymap.set('n', '<leader>hr', gs.reset_hunk,
                        { buffer = bufnr, desc = "Reset hunk [gitsigns.nvim]" })
                    vim.keymap.set('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
                        { buffer = bufnr, desc = "Stage hunk (visual) [gitsigns.nvim]" })
                    vim.keymap.set('v', '<leader>hr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
                        { buffer = bufnr, desc = "Reset hunk (visual) [gitsigns.nvim]" })

                    vim.keymap.set('n', '<leader>hS', gs.stage_buffer,
                        { buffer = bufnr, desc = "Stage buffer [gitsigns.nvim]" })
                    vim.keymap.set('n', '<leader>hR', gs.reset_buffer,
                        { buffer = bufnr, desc = "Reset buffer [gitsigns.nvim]" })

                    vim.keymap.set('n', '<leader>hp', gs.preview_hunk,
                        { buffer = bufnr, desc = "Preview hunk [gitsigns.nvim]" })
                    vim.keymap.set('n', '<leader>hb', function() gs.blame_line { full = true } end,
                        { buffer = bufnr, desc = "Blame line [gitsigns.nvim]" })

                    vim.keymap.set('n', '<leader>hd', gs.diffthis, { buffer = bufnr, desc = "Show diff [gitsigns.nvim]" })
                    vim.keymap.set('n', '<leader>hD', function() gs.diffthis('~') end,
                        { buffer = bufnr, desc = "Show diff [gitsigns.nvim]" })

                    vim.keymap.set('n', '<leader>hl', gs.setloclist,
                        { buffer = bufnr, desc = "Open loclist (hunks for file) [gitsigns.nvim]" })

                    vim.keymap.set({ 'o', 'x' }, 'ih', gs.select_hunk,
                        { buffer = bufnr, desc = "Select hunk (text object) [gitsigns.nvim]" })
                end
            }

            -- It's global binding
            vim.keymap.set('n', '<leader>hq', function() gs.setqflist('all') end,
                { desc = "Open qfix (hunks for git directory) [gitsigns.nvim]" })
        end
    },

    { 'akinsho/git-conflict.nvim', version = "*", config = true }
}
