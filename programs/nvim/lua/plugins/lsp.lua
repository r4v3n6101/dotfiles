return {
    {
        "neovim/nvim-lspconfig",
        config = function()
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    local b = ev.buf
                    vim.bo[b].omnifunc = 'v:lua.vim.lsp.omnifunc'

                    -- Diagnostics
                    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float,
                        { buffer = b, desc = "Open diagnostic float window [nivm-lspconfig]" })
                    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev,
                        { buffer = b, desc = "Goto previous diagnostic [nvim-lspconfig]" })
                    vim.keymap.set('n', ']d', vim.diagnostic.goto_next,
                        { buffer = b, desc = "Goto next diagnostic [nvim-lspconfig]" })

                    -- Go to + references
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration,
                        { buffer = b, desc = "Go to declaration [nvim-lspconfig]" })
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition,
                        { buffer = b, desc = "Go to definition [nvim-lspconfig]" })
                    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation,
                        { buffer = b, desc = "Go to implementation [nvim-lspconfig]" })
                    vim.keymap.set('n', 'gr', vim.lsp.buf.references,
                        { buffer = b, desc = "Show references [nvim-lspconfig]" })

                    -- Help
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = b, desc = "Hover [nvim-lspconfig]" })
                    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help,
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
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        opts = {},
    },

    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require 'mason-lspconfig'.setup {
                handlers = {
                    function(server_name)
                        require("lspconfig")[server_name].setup {}
                    end,

                    ["lua_ls"] = function()
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
                    end
                }
            }
        end
    },

    {
        'j-hui/fidget.nvim',
        opts = {},
    },


    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
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
