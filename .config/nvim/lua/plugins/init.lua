local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

require('packer').startup(function(use)
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
    config = require('plugins.cmp'),
  }
  use {
    'nvim-treesitter/nvim-treesitter',
    config = require('plugins.treesitter'),
    run = ':TSUpdate'
  }
  use { 
    'simrat39/rust-tools.nvim', 
    requires = { 'neovim/nvim-lspconfig' },
    config = require('plugins.rust-tools')
  }

  vim.cmd([[
    autocmd BufWritePost */plugins/init.lua source <afile> | PackerCompile
  ]])

  if packer_bootstrap then
    require('packer').sync()
  end
end)
