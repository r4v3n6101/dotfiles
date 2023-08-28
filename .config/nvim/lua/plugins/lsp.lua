local kmap = vim.keymap.set
local function opts(buf, desc)
    return { buffer = buf, desc = desc }
end

return {
    {
        "neovim/nvim-lspconfig",
        config = function()
            vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
            vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    local b = ev.buf
                    vim.bo[b].omnifunc = 'v:lua.vim.lsp.omnifunc'

                    kmap('n', 'gD', vim.lsp.buf.declaration, opts(b, "go to declaration [lspconfig]"))
                    kmap('n', 'gd', vim.lsp.buf.definition, opts(b, "go to definition [lspconfig]"))
                    kmap('n', 'K', vim.lsp.buf.hover, opts(b, "hover [lspconfig]"))
                    kmap('n', 'gi', vim.lsp.buf.implementation, opts(b, "go to implementation [lspconfig]"))
                    kmap('n', '<C-k>', vim.lsp.buf.signature_help, opts(b, "signature help [lspconfig]"))
                    kmap('n', '<leader>r', vim.lsp.buf.rename, opts(b, "rename [lspconfig]"))
                    kmap({ 'n', 'v' }, 'ga', vim.lsp.buf.code_action, opts(b, "code action [lspconfig]"))
                    kmap('n', 'gr', vim.lsp.buf.references, opts(b, "show references [lspconfig]"))
                    kmap('n', '<leader>f', vim.lsp.buf.format, opts(b, "format [lspconfig]"))
                end
            })
        end
    },

    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = function()
            require "mason".setup()
        end
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
        "rcarriga/nvim-dap-ui",
        dependencies = {
            "mfussenegger/nvim-dap"
        },
        config = function()
            local dap = require 'dap'
            local dapui = require 'dapui'
            dapui.setup()

            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserDapConfig', {}),
                callback = function(ev)
                    local b = ev.buf

                    kmap('n', '<leader>db', dap.toggle_breakpoint, opts(b, "toggle breakpoint [dap]"))
                    kmap('n', '<leader>dc', dap.toggle_breakpoint, opts(b, "continue execution [dap]"))
                    kmap('n', '<leader>do', dap.step_over, opts(b, "step over [dap]"))
                    kmap('n', '<leader>di', dap.step_into, opts(b, "step into [dap]"))

                    kmap('n', '<leader>du', dapui.toggle, opts(b, "open ui [dap-ui]"))
                end
            })
        end
    },

    {
        "jay-babu/mason-nvim-dap.nvim",
        config = function()
            require('mason-nvim-dap').setup()
        end
    }
}
