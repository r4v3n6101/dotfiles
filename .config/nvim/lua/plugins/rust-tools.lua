local lsp_status = require('lsp-status')
lsp_status.register_progress()

require('rust-tools').setup({
  hover_with_actions = false,
  server = {
    on_attach = lsp_status.on_attach,
    capabilities = lsp_status.capabilities,
  },
})
