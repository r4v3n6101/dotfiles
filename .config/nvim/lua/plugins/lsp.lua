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
                    vim.keymap.set({ 'n', 'v' }, 'ga', vim.lsp.buf.code_action,
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

    -- Temporary, later will be replaced with core functional of neovim
    { "simrat39/rust-tools.nvim" },

    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require 'mason-lspconfig'.setup {
                handlers = {
                    function(server_name)
                        require("lspconfig")[server_name].setup {}
                    end,

                    ["rust_analyzer"] = function()
                        -- codelldb as Rust's DAP
                        local mason_registry = require('mason-registry')
                        local codelldb_root = mason_registry.get_package("codelldb"):get_install_path() .. "/extension/"
                        local codelldb_path = codelldb_root .. "adapter/codelldb"
                        local liblldb_path = codelldb_root .. "lldb/lib/liblldb"

                        local this_os = vim.loop.os_uname().sysname
                        if this_os:find "Windows" then
                            codelldb_path = codelldb_root .. "adapter\\codelldb.exe"
                            liblldb_path = codelldb_root .. "lldb\\lib\\liblldb.dll"
                        else
                            liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
                        end

                        require("rust-tools").setup {
                            dap = {
                                adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
                            }
                        }
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
}
