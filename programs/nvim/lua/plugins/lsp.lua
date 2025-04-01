return {
    {
        "mrcjkb/rustaceanvim",
        lazy = false,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            -- nixd
            require 'lspconfig'.nixd.setup {}

            -- rust-analyzer
            local rustc_source = nil
            if vim.env.RUSTC_SRC ~= nil then
                rustc_source = vim.env.RUSTC_SRC
            end

            local target_dir = nil
            local default_target_dir = vim.fn.getenv('CARGO_TARGET_DIR')
            if default_target_dir ~= vim.v.null then
                target_dir = default_target_dir .. "/rust-analyzer"
            end

            vim.g.rustaceanvim = {
                server = {
                    handlers = {
                        ["experimental/serverStatus"] = function(_, result, ctx, _)
                            if result.quiescent then
                                for _, bufnr in ipairs(vim.lsp.get_buffers_by_client_id(ctx.client_id)) do
                                    vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
                                    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                                end
                            end
                        end,
                    },
                    default_settings = {
                        ["rust-analyzer"] = {
                            files = {
                                excludeDirs = { ".direnv", ".git", ".gitlab" }
                            },
                            cargo = {
                                allFeatures = true,
                                targetDir = target_dir,
                            },
                            completion = {
                                autoimport = {
                                    enable = true,
                                },
                            },
                            checkOnSave = {
                                command = "clippy",
                            },
                            inlayHints = {
                                bindingModeHints = {
                                    enable = true,
                                },
                                closureReturnTypeHints = {
                                    enable = "always",
                                },
                                discriminantHints = {
                                    enable = "always",
                                },
                                lifetimeElisionHints = {
                                    enable = "skip_trivial",
                                    useParameterNames = true,
                                },
                                rangeExclusiveHints = {
                                    enable = true,
                                },
                                expressionAdjustmentHints = {
                                    -- Currently broken: https://github.com/neovim/neovim/issues/29647
                                    -- enable = "reborrow",
                                    -- mode = "postfix",
                                },
                            },
                            procMacro = {
                                enable = true,
                            },
                            rustc = {
                                source = rustc_source,
                            },
                        }
                    }
                },
            }

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

            -- Remove default bindings
            vim.keymap.del('n', 'grn')
            vim.keymap.del('n', 'gra')
            vim.keymap.del('n', 'grr')
            vim.keymap.del('n', 'gri')
            vim.keymap.del('n', 'gO')
            vim.keymap.del('i', '<C-s>')

            -- Keymaps for lsp servers
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    local client = vim.lsp.get_client_by_id(ev.data.client_id)

                    -- Enable auto-completion
                    -- vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })

                    -- Virtual text (inlay hints & diagnostics)
                    vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
                    vim.diagnostic.config {
                        virtual_text = true,
                        virtual_lines = false,
                    }

                    -- LSP actions
                    vim.keymap.set('n', "<leader>gd", vim.lsp.buf.definition,
                        { buffer = ev.buf, desc = "Go to definition [nvim-lspconfig]" })
                    vim.keymap.set('n', "<leader>gD", vim.lsp.buf.declaration,
                        { buffer = ev.buf, desc = "Go to declaration [nvim-lspconfig]" })
                    vim.keymap.set('n', "<leader>gt", vim.lsp.buf.type_definition,
                        { buffer = ev.buf, desc = "Go to type definition [nvim-lspconfig]" })
                    vim.keymap.set('n', "<leader>ga", vim.lsp.buf.code_action,
                        { buffer = ev.buf, desc = "Show code action [nvim-lspconfig]" })
                    vim.keymap.set('n', "<leader>gn", vim.lsp.buf.rename,
                        { buffer = ev.buf, desc = "Rename [nvim-lspconfig]" })
                    vim.keymap.set('n', "<leader>gr", vim.lsp.buf.references,
                        { buffer = ev.buf, desc = "Go to references [nvim-lspconfig]" })
                    vim.keymap.set('n', "<leader>gi", vim.lsp.buf.implementation,
                        { buffer = ev.buf, desc = "Go to implementation [nvim-lspconfig]" })
                    vim.keymap.set('n', "<leader>gs", vim.lsp.buf.document_symbol,
                        { buffer = ev.buf, desc = "Open document symbols in loclist [nvim-lspconfig]" })
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

            -- Disable inlay hints in insert mode
            local lsp_lines_helper = vim.api.nvim_create_augroup('LspLinesHelper', {})
            vim.api.nvim_create_autocmd('InsertEnter', {
                group = lsp_lines_helper,
                pattern = "*",
                callback = function()
                    vim.lsp.inlay_hint.enable(false, { bufnr = 0 })
                    vim.diagnostic.config {
                        virtual_text = false,
                        virtual_lines = false,
                    }
                    -- To update cursor position
                    vim.cmd [[ normal "hl" ]]
                end
            })
            vim.api.nvim_create_autocmd('InsertLeave', {
                group = lsp_lines_helper,
                pattern = "*",
                callback = function()
                    vim.lsp.inlay_hint.enable(true, { bufnr = 0 })
                    vim.diagnostic.config {
                        virtual_text = true,
                        virtual_lines = false,
                    }
                end
            })
        end
    },

    {
        'j-hui/fidget.nvim',
        opts = {},
    }
}
