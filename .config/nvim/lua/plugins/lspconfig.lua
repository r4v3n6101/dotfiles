local lspconfig = require('lspconfig')
local lsp_status = require('lsp-status')
lsp_status.register_progress()

local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    local map = vim.api.nvim_buf_set_keymap
    local default_opts = {noremap = true, silent = true}

    map(bufnr, 'n', 'K', [[ <cmd>lua vim.lsp.buf.hover()<CR> ]], default_opts)
    map(bufnr, 'n', 'gd', [[ <cmd>lua vim.lsp.buf.definition()<CR> ]],
        default_opts)
    map(bufnr, 'n', 'gi', [[ <cmd>lua vim.lsp.buf.implementation()<CR> ]],
        default_opts)
    map(bufnr, 'n', 'gr', [[ <cmd>lua vim.lsp.buf.references()<CR> ]],
        default_opts)
    map(bufnr, 'n', 'ga', [[ <cmd>lua vim.lsp.buf.code_action()<CR> ]],
        default_opts)
    map(bufnr, 'n', 'gf', [[ <cmd>lua vim.lsp.buf.formatting()<CR> ]],
        default_opts)

    lsp_status.on_attach(client)
end

local capabilities = lsp_status.capabilities

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
                globals = {'vim'}
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true)
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {enable = false}
        }
    }
}

-- rust-tools commands
require('rust-tools').setup {
    server = {on_attach = on_attach, capabilities = capabilities}
}

vim.cmd([[autocmd BufWritePre *.rs lua vim.lsp.buf.formatting_sync(nil, 1000)]])

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
