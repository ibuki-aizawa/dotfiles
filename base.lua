-- Neovim configuration file

-- undo ファイル用のディレクトリをvimと別に設定する
vim.cmd('set undodir=~/.nvim/undo')

-- ターミナルをインサートモードで開く
vim.cmd('autocmd TermOpen * startinsert')

-- keymap
local opts = {
	noremap = true,
	silent = true,
}

local keymap = vim.api.nvim_set_keymap

-- 基本的なキーマッピング(macOS向け)
keymap('n', '<D-s>', ':w<CR>', opts);

-- ウィンドウ切り替え
keymap('n', '<C-h>', '<C-w>h', opts);
keymap('n', '<C-k>', '<C-w>k', opts);
keymap('n', '<C-l>', '<C-w>l', opts);

-- ターミナル切り替え
keymap('n', 't', ':split<CR>:term<CR><C-\\><C-n>:resize 10<CR>i', opts);
keymap('n', '<C-j>', '<C-w>ji', opts);
keymap('t', '<C-w>', '<C-\\><C-n><C-w>', opts);
keymap('t', '<C-k>', '<C-\\><C-n><C-w>k', opts);

-- https://github.com/junegunn/vim-plug
local vim = vim;
local Plug = vim.fn['plug#'];

-- plug
vim.call('plug#begin')

Plug 'github/copilot.vim'
Plug('neoclide/coc.nvim', { ['branch'] = 'release' })
Plug('lambdalisue/fern.vim')
Plug('lambdalisue/fern-git-status.vim')
Plug('mattn/emmet-vim')

Plug('navarasu/onedark.nvim')
Plug('Mofiqul/vscode.nvim')

vim.call('plug#end')

-- colorscheme

require('onedark').setup {
	style = 'darker',
}
require('onedark').load()

-- coc
keymap('n', 'gd', '<Plug>(coc-definition)', opts)
keymap('n', 'gy', '<Plug>(coc-type-definition)', opts)
keymap('n', 'gi', '<Plug>(coc-implementation)', opts)
keymap('n', 'gr', '<Plug>(coc-references)', opts)

keymap('n', '<F12>', '<Plug>(coc-references)', opts)

-- fern
keymap('n', '<C-e>', ':Fern . -reveal=% -drawer -toggle -width=40<CR>', opts)

