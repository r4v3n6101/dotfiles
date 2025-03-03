return {
    {
        "neovim/nvim-lspconfig",
        config = function()
            -- nixd
            require 'lspconfig'.nixd.setup {}

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
                    local client = vim.lsp.get_client_by_id(ev.data.client_id)

                    -- Enable auto-completion
                    -- vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })

                    -- Help
                    vim.keymap.set({ 'n', 'i' }, '<C-k>', vim.lsp.buf.signature_help,
                        { buffer = ev.buf, desc = "Signature help [nvim-lspconfig]" })

                    -- Format on save
                    vim.api.nvim_create_autocmd('BufWritePre', {
                        buffer = ev.buf,
                        callback = function()
                            vim.lsp.buf.format({ bufnr = ev.buf, id = client.id })
                        end,
                    })
                end
            })
        end
    },

    {
        'j-hui/fidget.nvim',
        opts = {},
    }
}
