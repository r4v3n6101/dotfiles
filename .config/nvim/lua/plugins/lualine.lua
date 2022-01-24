require('lualine').setup({
  options = {
    theme = 'gruvbox',
    icons_enabled = false,
  },
  sections = {
    lualine_c = { ..., 'lsp_progress' }
  }
})
