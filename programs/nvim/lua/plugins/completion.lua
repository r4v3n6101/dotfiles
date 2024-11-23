return {
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        opts = {
            enable_check_bracket_line = false
        }
    },

    {
        'hrsh7th/nvim-cmp',
        event = "InsertEnter",
        dependencies = {
            'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path',
            'hrsh7th/cmp-calc', 'hrsh7th/cmp-vsnip', 'hrsh7th/vim-vsnip'
        },
        config = function()
            local cmp = require('cmp')

            cmp.setup({
                snippet = { expand = function(args) vim.fn["vsnip#anonymous"](args.body) end },

                mapping = {
                    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
                    ['<Tab>'] = cmp.mapping.select_next_item(),
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete({}),
                    ['<C-e>'] = cmp.mapping.close(),
                    ['<CR>'] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = true
                    })
                },

                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'path' },
                    { name = 'buffer' },
                    { name = 'calc' },
                    { name = 'vsnip' },
                }
            })
        end,
    }
}
