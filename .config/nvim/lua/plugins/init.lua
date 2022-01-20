local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

vim.cmd([[packadd packer.nvim]])
require('packer').startup(function()
  use 'wbthomason/packer.nvim'
  use {
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-calc',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/vim-vsnip',
    },
    config = function() require('plugins.cmp') end,
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    config = function() require('plugins.treesitter') end,
    run = ':TSUpdate'
  }
  use { 
    'simrat39/rust-tools.nvim',
    requires = {
      'neovim/nvim-lspconfig',
      'nvim-lua/lsp-status.nvim',
      {
        'nvim-lualine/lualine.nvim', 
        config = function() require('plugins.lualine') end,
      },
      'arkav/lualine-lsp-progress',
    },
    config = function() require('plugins.rust-tools') end,
  }
  use {
    'savq/melange',
    config = function() require('plugins.melange') end,
  }
  use {
    'lukas-reineke/indent-blankline.nvim',
    config = function() require('plugins.indent-blankline') end,
  }

  vim.cmd([[
    autocmd BufWritePost */plugins/init.lua source <afile> | PackerCompile
  ]])

  if packer_bootstrap then
    require('packer').sync()
  end
end)
