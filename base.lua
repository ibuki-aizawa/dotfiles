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
keymap('n', 't', ':split<CR>:term<CR><C-\\><C-n>:resize 15<CR>i', opts);
-- keymap('n', '<C-j>', '<C-w>ji', opts);
keymap('t', '<C-w>', '<C-\\><C-n><C-w>', opts);
-- keymap('t', '<C-k>', '<C-\\><C-n><C-w>k', opts);

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

-- vim.cmd.colorscheme "vscode"

require('onedark').setup {
	style = 'deep',
}
require('onedark').load()

-- coc
keymap('n', 'gd', '<Plug>(coc-definition)', opts)
keymap('n', 'gy', '<Plug>(coc-type-definition)', opts)
keymap('n', 'gi', '<Plug>(coc-implementation)', opts)
keymap('n', 'gr', '<Plug>(coc-references)', opts)

keymap('n', '<F12>', '<Plug>(coc-definition)', opts)

-- fern
keymap('n', '<C-e>', ':Fern . -reveal=% -drawer -toggle -width=40<CR>', opts)

keymap('n', '<C-s>', ':vs tmp<CR>:r! grep -Ril ', opts);
keymap('n', '<F11>', 'yy:e! <C-r>0<CR>', opts);


function split(str, ts)
  -- 引数がないときは空tableを返す
  if ts == nil then return {} end

  local t = {} ;
  i=1
  for s in string.gmatch(str, "([^"..ts.."]+)") do
    t[i] = s
    i = i + 1
  end

  return t
end


-- フローティングウィンドウの作成とキーマップの設定
local function create_float_window(str)
  -- ウィンドウの内容
  local command = 'grep -Rinl --color=auto --exclude-dir={node_modules,.git,dist,.next,build} ' .. str;
  print(command)

  local handle = io.popen(command)
  local ret = handle:read("*a")

  local content = split(ret, "\n")
  handle:close()

  -- バッファを作成
  local buf = vim.api.nvim_create_buf(false, true)

  -- バッファに内容を設定
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)

  -- ウィンドウの幅と高さを計算
  local width = 60
  local height = table.getn(content);

  -- エディタの中央に配置するための位置を計算
  local ui = vim.api.nvim_list_uis()[1]
  local row = math.floor((ui.height - height) / 2 - 1)
  local col = math.floor((ui.width - width) / 2)

  -- ウィンドウオプション
  local opts = {
    relative = "editor",
    width = width,
    -- height = height,
    height = 20,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = str,
    title_pos = "center"
  }

  -- ウィンドウを作成
  local win = vim.api.nvim_open_win(buf, true, opts)

  -- ウィンドウのハイライト設定
  vim.api.nvim_win_set_option(win, "winhl", "Normal:FloatBorder")

  -- 終了
  vim.api.nvim_buf_set_keymap(buf, 'n', '<Esc><Esc>',
    ':lua vim.api.nvim_win_close(' .. win .. ', true)<CR>',
    {silent = true, noremap = true}
  )

  vim.api.nvim_buf_set_keymap(buf, 'n', '<CR>',
    'Y:q<CR>:e <C-r>0<CR>',
    {silent = true, noremap = true}
  )

  -- ウィンドウを離れたときに自動的に閉じる（オプション）
  vim.api.nvim_command('autocmd WinLeave <buffer=' .. buf .. '> lua vim.api.nvim_win_close(' .. win .. ', true)')

  return buf, win
end

-- 内容をリロードする関数
function reload_float_content(str, buf)
  local command = 'grep -Rinl --color=auto --exclude-dir={node_modules,.git,dist,.next,build} ' .. #str;
  local handle = io.popen(command)
  local ret = handle:read("*a")

  print(ret)

  local new_content = split(ret, "\n")
  handle:close()

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, new_content)
  print("内容をリロードしました")
end

-- アクションを実行する関数
function execute_action()
  print("アクションが実行されました")
  -- ここに実際のアクションコードを記述
end

-- コマンドを登録
vim.api.nvim_create_user_command(
  'Grepf',
  function(opts)
    create_float_window(opts.args)
  end,
  {
    nargs = '?'
  }
)

