local vim = vim;
local global = vim.g

-- Neovim configuration file
vim.cmd('source ~/.vimrc')

-- undo ファイル用のディレクトリをvimと別に設定する
vim.cmd('set undodir=~/.nvim/undo')

-- 読み込み
require('core')
require('plugins')

-- colorscheme

-- require('onedark').setup {
-- 	style = 'darker',
-- }
-- require('onedark').load()
vim.cmd.colorscheme "catppuccin"
-- vim.cmd.colorscheme "habamax"
-- vim.cmd.colorscheme "xamabah"

-- vim.cmd("autocmd CursorHold *.{ts,c,cpp,hpp,hs,py} if (coc#rpc#ready() && CocHasProvider('hover') && !coc#float#has_float()) | silent call CocActionAsync('doHover') | endif")
-- vim.cmd("autocmd CursorHold * silent call CocActionAsync('highlight')")

-- コパイロット
global.copilot_no_tab_map = true

