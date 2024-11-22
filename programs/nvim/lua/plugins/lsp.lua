return {
    {
        "neovim/nvim-lspconfig",
        config = function()
            -- rust-analyzer
            require 'lspconfig'.rust_analyzer.setup {}

            -- lua-ls
            local runtime_path = vim.split(package.path, ';')
            table.insert(runtime_path, "lua/?.lua")
            table.insert(runtime_path, "lua/?/init.lua")

            require 'lspconfig'.lua_ls.setup {
                settings = {
                    Lua = {
                        runtime = {
                            version = 'LuaJIT',
                            path = runtime_path
                        },
                        diagnostics = {
                            globals = { 'vim' }
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true)
                        },
                        telemetry = { enable = false }
                    }
                }
            }

            -- Keymaps for lsp servers
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    local b = ev.buf
                    vim.bo[b].omnifunc = 'v:lua.vim.lsp.omnifunc'

                    -- Diagnostics
                    vim.keymap.set('n', '<leader>e', "<cmd>Trouble diagnostics toggle focus=true<cr>",
                        { buffer = b, desc = "Open diagnostic float window [trouble.nivm/nivm-lspconfig]" })
                    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev,
                        { buffer = b, desc = "Goto previous diagnostic [nvim-lspconfig]" })
                    vim.keymap.set('n', ']d', vim.diagnostic.goto_next,
                        { buffer = b, desc = "Goto next diagnostic [nvim-lspconfig]" })

                    -- Go to + references
                    vim.keymap.set('n', 'gD', "<cmd>Trouble lsp_declarations toggle focus=true<cr>",
                        { buffer = b, desc = "Go to declaration [trouble.nvim/nvim-lspconfig]" })
                    vim.keymap.set('n', 'gd', "<cmd>Trouble lsp_definitions toggle focus=true<cr>",
                        { buffer = b, desc = "Go to definition [trouble.nvim/nvim-lspconfig]" })
                    vim.keymap.set('n', 'gi', "<cmd>Trouble lsp_implementations toggle focus=true<cr>",
                        { buffer = b, desc = "Go to implementation [trouble.nvim/nvim-lspconfig]" })
                    vim.keymap.set('n', 'gr', "<cmd>Trouble lsp_references toggle focus=true<cr>",
                        { buffer = b, desc = "Show references [trouble.nvim/nvim-lspconfig]" })

                    -- Help
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = b, desc = "Hover [nvim-lspconfig]" })
                    vim.keymap.set({ 'n', 'i' }, '<C-k>', vim.lsp.buf.signature_help,
                        { buffer = b, desc = "Signature help [nvim-lspconfig]" })

                    -- Code actions
                    vim.keymap.set({ 'n', 'v' }, '<leader>c', vim.lsp.buf.code_action,
                        { buffer = b, desc = "Code action [nvim-lspconfig]" })
                    vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, { buffer = b, desc = "Rename [nvim-lspconfig]" })
                    vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, { buffer = b, desc = "Format [nvim-lspconfig]" })
                end
            })
        end
    },

    {
        'j-hui/fidget.nvim',
        opts = {},
    },

    {
        "hedyhli/outline.nvim",
        keys = {
            { "<C-s>", "<cmd>Outline<cr>", "Toggle outline (code structure) [outline.nvim]" }
        },
        opts = {},
    },

    {
        'kevinhwang91/nvim-ufo',
        dependencies = {
            'kevinhwang91/promise-async'
        },
        config = function()
            vim.o.foldcolumn = '1'
            vim.o.foldlevel = 99
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true

            local handler = function(virtText, lnum, endLnum, width, truncate)
                local newVirtText = {}
                local suffix = (' ~ %d '):format(endLnum - lnum)
                local sufWidth = vim.fn.strdisplaywidth(suffix)
                local targetWidth = width - sufWidth
                local curWidth = 0
                for _, chunk in ipairs(virtText) do
                    local chunkText = chunk[1]
                    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                    if targetWidth > curWidth + chunkWidth then
                        table.insert(newVirtText, chunk)
                    else
                        chunkText = truncate(chunkText, targetWidth - curWidth)
                        local hlGroup = chunk[2]
                        table.insert(newVirtText, { chunkText, hlGroup })
                        chunkWidth = vim.fn.strdisplaywidth(chunkText)
                        -- str width returned from truncate() may less than 2nd argument, need padding
                        if curWidth + chunkWidth < targetWidth then
                            suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
                        end
                        break
                    end
                    curWidth = curWidth + chunkWidth
                end
                table.insert(newVirtText, { suffix, 'MoreMsg' })
                return newVirtText
            end

            require('ufo').setup({
                fold_virt_text_handler = handler
            })

            vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = "Open all folds [nvim-ufo]" })
            vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = "Close all folds [nvim-ufo]" })
            vim.keymap.set('n', 'zv', function() require('ufo').peekFoldedLinesUnderCursor() end,
                { desc = "View fold under cursor [nvim-ufo]" })
        end
    }
}
