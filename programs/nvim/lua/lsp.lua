-- LSP enabling
vim.lsp.enable({ 'lua_ls', 'nil' })

-- Remove default bindings
vim.keymap.del('n', 'grn')
vim.keymap.del('n', 'gra')
vim.keymap.del('n', 'grr')
vim.keymap.del('n', 'gri')
vim.keymap.del('n', 'gO')
vim.keymap.del('i', '<C-s>')

-- Configuration for buffers when LSP attached to them
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)

        -- Enable auto-completion
        if client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, ev.buf, {
                autotrigger = true,
                -- FIXME: https://github.com/neovim/neovim/issues/29225
                convert = function(item)
                    local kind = vim.lsp.protocol.CompletionItemKind[item.kind] or ""
                    return {
                        menu = "",
                        kind_hlgroup = "CmpItemKind" .. kind,
                    }
                end,
            })
        end

        -- LSP actions
        vim.keymap.set('n', "<leader>gd", vim.lsp.buf.definition,
            { buffer = ev.buf, desc = "Go to definition" })
        vim.keymap.set('n', "<leader>gD", vim.lsp.buf.declaration,
            { buffer = ev.buf, desc = "Go to declaration" })
        vim.keymap.set('n', "<leader>gt", vim.lsp.buf.type_definition,
            { buffer = ev.buf, desc = "Go to type definition" })
        vim.keymap.set('n', "<leader>ga", vim.lsp.buf.code_action,
            { buffer = ev.buf, desc = "Show code action" })
        vim.keymap.set('n', "<leader>gn", vim.lsp.buf.rename,
            { buffer = ev.buf, desc = "Rename" })
        vim.keymap.set('n', "<leader>gr", vim.lsp.buf.references,
            { buffer = ev.buf, desc = "Go to references" })
        vim.keymap.set('n', "<leader>gi", vim.lsp.buf.implementation,
            { buffer = ev.buf, desc = "Go to implementation" })
        vim.keymap.set('n', "<leader>gs", vim.lsp.buf.document_symbol,
            { buffer = ev.buf, desc = "Open document symbols in loclist" })
        vim.keymap.set({ 'n', 'i' }, '<C-k>', vim.lsp.buf.signature_help,
            { buffer = ev.buf, desc = "Signature help" })

        -- Format on save
        vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = ev.buf,
            callback = function()
                vim.lsp.buf.format({ bufnr = ev.buf, id = client.id })
            end,
        })

        vim.api.nvim_create_autocmd("CompleteDone", {
            callback = function()
                vim.cmd("pclose")
            end
        })
    end
})

-- Diagnostics and inlay hints
SHOW_VIRTUAL_TEXT = true
DIAGNOSTICS_VIRTUAL_TEXT = true

vim.lsp.inlay_hint.enable(SHOW_VIRTUAL_TEXT)
vim.diagnostic.config {
    underline = true,
    signs = true,
    severity_sort = true,
    update_in_insert = true,
    virtual_text = DIAGNOSTICS_VIRTUAL_TEXT and SHOW_VIRTUAL_TEXT,
    virtual_lines = not DIAGNOSTICS_VIRTUAL_TEXT and SHOW_VIRTUAL_TEXT,
}

-- Show/hide diagnostics and inlay hints
vim.keymap.set('n', '<leader>t', function()
    SHOW_VIRTUAL_TEXT = not SHOW_VIRTUAL_TEXT
    vim.lsp.inlay_hint.enable(SHOW_VIRTUAL_TEXT)
    vim.diagnostic.config {
        virtual_text = DIAGNOSTICS_VIRTUAL_TEXT and SHOW_VIRTUAL_TEXT,
        virtual_lines = not DIAGNOSTICS_VIRTUAL_TEXT and SHOW_VIRTUAL_TEXT,
    }
    vim.cmd [[ normal "hl" ]]
end, { desc = "Show/hide diagnostics and inlay hints" })

-- Change type of diagnostics (virtual lines or virtual text)
vim.keymap.set('n', '<leader>l', function()
    DIAGNOSTICS_VIRTUAL_TEXT = not DIAGNOSTICS_VIRTUAL_TEXT
    vim.diagnostic.config {
        virtual_text = DIAGNOSTICS_VIRTUAL_TEXT and SHOW_VIRTUAL_TEXT,
        virtual_lines = not DIAGNOSTICS_VIRTUAL_TEXT and SHOW_VIRTUAL_TEXT,
    }
    vim.cmd [[ normal "hl" ]]
end, { desc = "Toggle virtual text/lines for diagnostics" })

-- Disable virtual text/lines in insert mode
local lsp_lines_helper = vim.api.nvim_create_augroup('LspLinesHelper', {})
vim.api.nvim_create_autocmd('InsertEnter', {
    group = lsp_lines_helper,
    pattern = "*",
    callback = function()
        vim.lsp.inlay_hint.enable(false)
        vim.diagnostic.config {
            virtual_text = false,
            virtual_lines = false,
        }
        vim.cmd [[ normal "hl" ]]
    end
})

-- Leaving insert mode will restore the state before entering insert mode
vim.api.nvim_create_autocmd('InsertLeave', {
    group = lsp_lines_helper,
    pattern = "*",
    callback = function()
        vim.lsp.inlay_hint.enable(SHOW_VIRTUAL_TEXT)
        vim.diagnostic.config {
            virtual_text = DIAGNOSTICS_VIRTUAL_TEXT and SHOW_VIRTUAL_TEXT,
            virtual_lines = not DIAGNOSTICS_VIRTUAL_TEXT and SHOW_VIRTUAL_TEXT,
        }
        vim.cmd [[ normal "hl" ]]
    end
})
