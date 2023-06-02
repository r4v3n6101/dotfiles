return {
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = function()
            require "mason".setup()
        end
    },
    {
        "simrat39/rust-tools.nvim"
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require 'mason-lspconfig'.setup {
                handlers = {
                    function(server_name)
                        require("lspconfig")[server_name].setup {}
                    end,
                    ["rust_analyzer"] = function()
                        require("rust-tools").setup {}
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
        "neovim/nvim-lspconfig",
        config = function()
            vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
            vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

            -- Use LspAttach autocommand to only map the following keys
            -- after the language server attaches to the current buffer
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    -- Enable completion triggered by <c-x><c-o>
                    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

                    local kmap = vim.keymap.set
                    local function opts(desc)
                        return { buffer = ev.buf, desc = desc }
                    end

                    kmap('n', 'gD', vim.lsp.buf.declaration, opts("go to declaration [lspconfig]"))
                    kmap('n', 'gd', vim.lsp.buf.definition, opts("go to definition [lspconfig]"))
                    kmap('n', 'K', vim.lsp.buf.hover, opts("hover [lspconfig]"))
                    kmap('n', 'gi', vim.lsp.buf.implementation, opts("go to implementation [lspconfig]"))
                    kmap('n', '<C-k>', vim.lsp.buf.signature_help, opts("signature help [lspconfig]"))
                    kmap('n', '<leader>D', vim.lsp.buf.type_definition, opts("type definition [lspconfig]"))
                    kmap('n', '<leader>r', vim.lsp.buf.rename, opts("rename [lspconfig]"))
                    kmap({ 'n', 'v' }, 'ga', vim.lsp.buf.code_action, opts("code action [lspconfig]"))
                    kmap('n', 'gr', vim.lsp.buf.references, opts("show references [lspconfig]"))
                    kmap('n', '<leader>f', vim.lsp.buf.format, opts("format [lspconfig]"))
                end
            })
        end
    }
}
