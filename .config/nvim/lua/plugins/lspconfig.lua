local kmap = vim.keymap.set

local opts = { noremap = true, silent = true }
kmap('n', '<space>d', vim.diagnostic.open_float, opts)
kmap('n', '[d', vim.diagnostic.goto_prev, opts)
kmap('n', ']d', vim.diagnostic.goto_next, opts)
local function on_attach(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    local bufopts = { noremap = true, silent = true, buffer = bufnr }

    kmap('n', 'K', vim.lsp.buf.hover, bufopts)
    kmap('n', 'ga', vim.lsp.buf.code_action, bufopts)
    kmap('n', 'gd', vim.lsp.buf.definition, bufopts)
    kmap('n', 'gi', vim.lsp.buf.implementation, bufopts)
    kmap('n', 'gr', vim.lsp.buf.references, bufopts)

    kmap('n', '<space>r', vim.lsp.buf.rename, bufopts)
    kmap('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

local capabilities = {}

local function cfg_lua()
    local runtime_path = vim.split(package.path, ';')
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")

    require 'lspconfig'.lua_ls.setup {
        on_attach = on_attach,
        capabilities = capabilities,
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

local function cfg_rust()
    require('rust-tools').setup {
        server = { on_attach = on_attach, capabilities = capabilities }
    }
end

local function cfg()
    cfg_lua()
    cfg_rust()
end

return {
    {
        'neovim/nvim-lspconfig',
        dependencies = { 'simrat39/rust-tools.nvim' },
        config = cfg
    },
}
