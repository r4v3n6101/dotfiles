vim.g.rustaceanvim = function()
    local rustc_source = nil
    if vim.env.RUSTC_SRC ~= nil then
        rustc_source = vim.env.RUSTC_SRC
    end

    local target_dir = nil
    local default_target_dir = vim.fn.getenv('CARGO_TARGET_DIR')
    if default_target_dir ~= vim.v.null then
        target_dir = default_target_dir .. "/rust-analyzer"
    end

    -- Update this path
    local extension_path = vim.env.HOME .. '/.vscode/extensions/vadimcn.vscode-lldb-1.10.0/'
    local codelldb_path = extension_path .. 'adapter/codelldb'
    local liblldb_path = extension_path .. 'lldb/lib/liblldb'
    local this_os = vim.uv.os_uname().sysname;

    -- The path is different on Windows
    if this_os:find "Windows" then
        codelldb_path = extension_path .. "adapter\\codelldb.exe"
        liblldb_path = extension_path .. "lldb\\bin\\liblldb.dll"
    else
        -- The liblldb extension is .so for Linux and .dylib for MacOS
        liblldb_path = liblldb_path .. (this_os == "Linux" and ".so" or ".dylib")
    end

    local cfg = require('rustaceanvim.config')
    return {
        dap = {
            adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
        },
        server = {
            handlers = {
                ["experimental/serverStatus"] = function(_, result, ctx, _)
                    if result.quiescent then
                        for _, bufnr in ipairs(vim.lsp.get_buffers_by_client_id(ctx.client_id)) do
                            vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
                            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                        end
                    end
                end,
            },
            default_settings = {
                ["rust-analyzer"] = {
                    files = {
                        excludeDirs = { ".direnv", ".git", ".gitlab" }
                    },
                    cargo = {
                        allFeatures = true,
                        targetDir = target_dir,
                    },
                    completion = {
                        autoimport = {
                            enable = true,
                        },
                    },
                    inlayHints = {
                        bindingModeHints = {
                            enable = true,
                        },
                        closureReturnTypeHints = {
                            enable = "always",
                        },
                        discriminantHints = {
                            enable = "always",
                        },
                        lifetimeElisionHints = {
                            enable = "skip_trivial",
                            useParameterNames = true,
                        },
                        rangeExclusiveHints = {
                            enable = true,
                        },
                        expressionAdjustmentHints = {
                            -- Currently broken: https://github.com/neovim/neovim/issues/29647
                            enable = "reborrow",
                            mode = "postfix",
                        },
                    },
                    procMacro = {
                        enable = true,
                    },
                    rustc = {
                        source = rustc_source,
                    },
                }
            }
        }
    }
end
