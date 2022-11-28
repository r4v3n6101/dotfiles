local lspconfig = require('lspconfig')

local kmap = vim.keymap.set

local opts = { noremap = true, silent = true }
kmap('n', '<space>d', vim.diagnostic.open_float, opts)
kmap('n', '[d', vim.diagnostic.goto_prev, opts)
kmap('n', ']d', vim.diagnostic.goto_next, opts)
local on_attach = function(client, bufnr)
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

-- Lua LSP
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

lspconfig.sumneko_lua.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path = runtime_path
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' }
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true)
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = { enable = false }
        }
    }
}

-- rust-tools commands
require('rust-tools').setup {
    server = { on_attach = on_attach, capabilities = capabilities }
}

-- yaml LSP
lspconfig.yamlls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        yaml = {
            schemas = {
                ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*"
            }
        }
    }
}
