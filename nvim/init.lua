local vim = vim;
local global = vim.g

-- Neovim configuration file
vim.cmd('source ~/.vimrc')

-- undo ファイル用のディレクトリをvimと別に設定する
vim.cmd('set undodir=~/.nvim/undo')

-- 読み込み
--require('plugins.coc.init')

require('core')
require('plugins')

-- require('mark')
-- require('git')

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

vim.g.coc_global_extensions = {
  "coc-git",
  "coc-json",
  "coc-lua",
  "coc-tsserver",
  "coc-explorer",
  "coc-pyright",
  "coc-rust-analyzer",
  "coc-pairs",
  "coc-lists",
}

-- colorscheme

-- require('onedark').setup {
-- 	style = 'darker',
-- }
-- require('onedark').load()
vim.cmd.colorscheme "catppuccin"
-- vim.cmd.colorscheme "habamax"
-- vim.cmd.colorscheme "xamabah"

-- coc

-- vim.cmd("autocmd CursorHold *.{ts,c,cpp,hpp,hs,py} if (coc#rpc#ready() && CocHasProvider('hover') && !coc#float#has_float()) | silent call CocActionAsync('doHover') | endif")
-- vim.cmd("autocmd CursorHold * silent call CocActionAsync('highlight')")

-- コパイロット
global.copilot_no_tab_map = true

-- use rg for external-grep
vim.opt.grepprg = table.concat({
  'rg',
  '--vimgrep',
  '--trim',
  '--hidden',
  [[--glob='!.git']],
  [[--glob='!*.lock']],
  [[--glob='!*-lock.json']],
  [[--glob='!*generated*']],
  -- [[--glob='!openapi.yaml']],
  -- [[--glob='!**.spec.ts']],
}, ' ')
vim.opt.grepformat = '%f:%l:%c:%m'
