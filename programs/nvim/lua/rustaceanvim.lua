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

    return {
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
