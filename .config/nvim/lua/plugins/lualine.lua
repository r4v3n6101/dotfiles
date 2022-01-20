require('lualine').setup({
  options = { theme = 'gruvbox' },
  sections = {
    lualine_c = { ..., 'lsp_progress' }
  }
})
