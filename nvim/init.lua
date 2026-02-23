local vim = vim;

-- Neovim configuration file
vim.cmd('source ~/.vimrc')

-- undo ファイル用のディレクトリをvimと別に設定する
vim.cmd('set undodir=~/.nvim/undo')

-- 読み込み
require('plugins').init()
require('core')
