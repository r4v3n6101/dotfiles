local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({
        'git', 'clone', '--depth', '1',
        'https://github.com/wbthomason/packer.nvim', install_path
    })
end

vim.cmd([[packadd packer.nvim]])
require('packer').startup(function()
    use 'wbthomason/packer.nvim'

    -- syntax highlighting, lsp
    use {
        'neovim/nvim-lspconfig',
        config = function()
            require('plugins.lspconfig')
        end
    }
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path',
            'hrsh7th/cmp-calc', 'hrsh7th/cmp-vsnip', 'hrsh7th/vim-vsnip'
        },
        config = function()
            require('plugins.cmp')
        end
    }
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = { 'rust', 'lua' },
                highlight = { enable = true },
                indent = { enable = true }
            })
        end,
    }

    --[[ use {
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = function() require('plugins.lsplines') end,
    } ]] --

    -- visual
    use {
        'j-hui/fidget.nvim',
        config = function()
            require('fidget').setup()
        end
    }
    use {
        'jacoborus/tender.vim',
        config = function()
            vim.opt.termguicolors = true
            vim.cmd([[colorscheme tender]])
        end
    }
    use {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            require("indent_blankline").setup {
                show_end_of_line = true,
                space_char_blankline = " "
            }
        end
    }
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function ()
            require("plugins.telescope")
        end
    }

    -- lang plugins
    use 'simrat39/rust-tools.nvim'
    use {
        'saecki/crates.nvim',
        tag = 'v0.3.0',
        event = { "BufRead Cargo.toml" },
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('plugins.crates')
        end
    }

    vim.cmd([[ autocmd BufWritePost */plugins/init.lua source <afile> | PackerCompile ]])

    if packer_bootstrap then require('packer').sync() end
end)
