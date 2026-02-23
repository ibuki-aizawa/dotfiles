local vim = vim;

-- https://github.com/junegunn/vim-plug
local Plug = vim.fn['plug#'];

-- plug
vim.call('plug#begin')
Plug 'vim-jp/vimdoc-ja'

Plug('junegunn/fzf')
Plug('junegunn/fzf.vim')

Plug('neoclide/coc.nvim', { ['branch'] = 'release' })
-- Plug('lambdalisue/fern.vim')
-- Plug('lambdalisue/fern-git-status.vim')
-- Plug('mattn/emmet-vim')

-- Python
Plug 'Vigemus/iron.nvim'

Plug('navarasu/onedark.nvim')
-- Plug('Mofiqul/vscode.nvim')
Plug('catppuccin/nvim', { ['as'] = 'catppuccin' })

Plug 'rust-lang/rust.vim'

Plug 'github/copilot.vim'

vim.call('plug#end')
