return {
    "lewis6991/gitsigns.nvim",
    config = function()
        require('gitsigns').setup {
            numhl = true,
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns

                vim.keymap.set('n', ']h', function()
                    if vim.wo.diff then return ']h' end
                    vim.schedule(function() gs.next_hunk() end)
                    return '<Ignore>'
                end, { buffer = bufnr, desc = "Next hunk [gitsigns.nvim]", expr = true })

                vim.keymap.set('n', '[h', function()
                    if vim.wo.diff then return '[h' end
                    vim.schedule(function() gs.prev_hunk() end)
                    return '<Ignore>'
                end, { buffer = bufnr, desc = "Previous hunk [gitsigns.nvim]", expr = true })

                vim.keymap.set('n', '<leader>hs', gs.stage_hunk, { buffer = bufnr, desc = "Stage hunk [gitsigns.nvim]" })
                vim.keymap.set('n', '<leader>hr', gs.reset_hunk, { buffer = bufnr, desc = "Reset hunk [gitsigns.nvim]" })
                vim.keymap.set('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
                    { buffer = bufnr, desc = "Stage hunk (visual) [gitsigns.nvim]" })
                vim.keymap.set('v', '<leader>hr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
                    { buffer = bufnr, desc = "Reset hunk (visual) [gitsigns.nvim]" })
                vim.keymap.set('n', '<leader>hS', gs.stage_buffer,
                    { buffer = bufnr, desc = "Stage buffer [gitsigns.nvim]" })
                vim.keymap.set('n', '<leader>hu', gs.undo_stage_hunk,
                    { buffer = bufnr, desc = "Undo stage hunk [gitsigns.nvim]" })
                vim.keymap.set('n', '<leader>hR', gs.reset_buffer,
                    { buffer = bufnr, desc = "Reset buffer [gitsigns.nvim]" })
                vim.keymap.set('n', '<leader>hp', gs.preview_hunk,
                    { buffer = bufnr, desc = "Preview hunk [gitsigns.nvim]" })
                vim.keymap.set('n', '<leader>hb', function() gs.blame_line { full = true } end,
                    { buffer = bufnr, desc = "Blame line [gitsigns.nvim]" })
                vim.keymap.set('n', '<leader>hd', gs.diffthis, { buffer = bufnr, desc = "Show diff [gitsigns.nvim]" })
                vim.keymap.set('n', '<leader>hD', function() gs.diffthis('~') end,
                    { buffer = bufnr, desc = "Show diff [gitsigns.nvim]" })
                vim.keymap.set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>',
                    { buffer = bufnr, desc = "Select hunk (text object) [gitsigns.nvim]" })
                vim.keymap.set('n', '<leader>hl', gs.setloclist,
                    { buffer = bufnr, desc = "Open loclist (hunks for file) [gitsigns.nvim]" })
            end
        }

        vim.keymap.set('n', '<leader>hq', "<cmd>Gitsigns setqflist all<cr>",
            { desc = "Open quickfix (hunks for git directory) [gitsigns.nvim]" })
    end
}
