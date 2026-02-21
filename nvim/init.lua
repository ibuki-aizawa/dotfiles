local vim = vim;
local global = vim.g

-- Neovim configuration file
vim.cmd('source ~/.vimrc')

-- COC 設定
vim.cmd('source ~/.config/nvim/coc.vim')

-- undo ファイル用のディレクトリをvimと別に設定する
vim.cmd('set undodir=~/.nvim/undo')

-- 読み込み
require('git')
require('keymap')
require('mark')

-- ターミナルをインサートモードで開く
vim.cmd('autocmd TermOpen * startinsert')

-- キャメルケース変換関数
local function to_camel_case()
  -- ビジュアルモードの開始点と終了点を取得
  -- table.unpack を使用
  local _unpack = table.unpack or unpack
  local _, s_row, s_col, _ = _unpack(vim.fn.getpos("'<"))
  local _, e_row, e_col, _ = _unpack(vim.fn.getpos("'>"))

  -- 選択範囲のテキストを取得
  local lines = vim.api.nvim_buf_get_text(0, s_row - 1, s_col - 1, e_row - 1, e_col, {})
  if #lines == 0 then return end

  -- 文字列を結合して変換 (snake_case -> camelCase)
  local text = table.concat(lines, "\n")
  local camel = text:gsub("(_)([a-z])", function(_, l)
    return l:upper()
  end)

  -- バッファに書き戻し
  vim.api.nvim_buf_set_text(0, s_row - 1, s_col - 1, e_row - 1, e_col, { camel })
end

-- ユーザーコマンド :Camel の登録
vim.api.nvim_create_user_command('Camel', to_camel_case, { range = true })

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
