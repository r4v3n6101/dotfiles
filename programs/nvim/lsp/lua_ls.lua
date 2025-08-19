return {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
    settings = {
        Lua = {
            diagnostics = { globals = { 'vim' } },
            telemetry = { enable = false },
            runtime = {
                version = 'LuaJIT',
                path = {
                    'lua/?.lua',
                    'lua/?/init.lua',
                },
            },
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                    -- vim.api.nvim_get_runtime_file('', true),
                    -- '${3rd}/busted/library'
                },
            },
        },
    },
}
