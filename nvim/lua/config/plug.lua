local vim = vim;

-- require('config.coc')

local M = {}

function M.init()
  -- https://github.com/junegunn/vim-plug
  local Plug = vim.fn['plug#'];

  -- plug
  vim.call('plug#begin')
  Plug 'vim-jp/vimdoc-ja'

  -- fzf
  -- Plug('junegunn/fzf')
  -- Plug('junegunn/fzf.vim')

  -- telescope
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'

  Plug('nvim-telescope/telescope-fzf-native.nvim', { ['do'] = 'make' })

  -- nvim-cmp
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'

  -- autopairs
  Plug 'windwp/nvim-autopairs'

  -- oil.vim (ファイルエクスプローラ）
  Plug 'stevearc/oil.nvim'

  -- ファイルエクスプローラ
  Plug 'nvim-neo-tree/neo-tree.nvim'
  Plug 'MunifTanjim/nui.nvim'

  -- Plug('neoclide/coc.nvim', { ['branch'] = 'release' })
  -- Plug('lambdalisue/fern.vim')
  -- Plug('lambdalisue/fern-git-status.vim')
  -- Plug('mattn/emmet-vim')

  -- Python
  -- Plug 'Vigemus/iron.nvim'

  --Plug('navarasu/onedark.nvim')
  -- Plug('Mofiqul/vscode.nvim')
  Plug('catppuccin/nvim', { ['as'] = 'catppuccin' })

  Plug 'rust-lang/rust.vim'

  --Plug 'github/copilot.vim'

  Plug 'stevearc/conform.nvim'

  vim.call('plug#end')
end

return M
