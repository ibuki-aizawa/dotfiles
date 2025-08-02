-- Neovim configuration file
vim.cmd('source ~/.vimrc')

-- COC 設定
vim.cmd('source ~/.config/nvim/coc.vim')

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

-- command + s で保存(macOS)
keymap('n', '<D-s>', ':w<CR>', opts);

keymap('n', 'n', 'nzz', opts);
keymap('n', 'N', 'Nzz', opts);

keymap('n', 'gj', '10jzz', opts);
keymap('n', 'gk', '10kzz', opts);
keymap('n', 'gl', '10lzz', opts);
keymap('n', 'gh', '10hzz', opts);

-- ウィンドウ切り替え
-- keymap('n', '<C-h>', '<C-w>h', opts);
-- keymap('n', '<C-k>', '<C-w>k', opts);
-- keymap('n', '<C-l>', '<C-w>l', opts);

-- ターミナル表示
keymap('n', 'gt', ':split<CR>:term<CR><C-\\><C-n>:resize 15<CR>i', opts);

-- ターミナルからスムーズにウィンドウ切り替えできるように
keymap('t', '<C-w>', '<C-\\><C-n><C-w>', opts);

-- https://github.com/junegunn/vim-plug
local vim = vim;
local Plug = vim.fn['plug#'];

-- plug
vim.call('plug#begin')

Plug 'github/copilot.vim'
Plug('neoclide/coc.nvim', { ['branch'] = 'release' })
-- Plug('lambdalisue/fern.vim')
-- Plug('lambdalisue/fern-git-status.vim')
-- Plug('mattn/emmet-vim')

-- Python
Plug 'Vigemus/iron.nvim'

Plug('navarasu/onedark.nvim')
-- Plug('Mofiqul/vscode.nvim')

vim.call('plug#end')

-- iron
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    local iron = require("iron.core")
    local view = require("iron.view")
    local common = require("iron.fts.common")

    iron.setup {
      config = {
        -- Whether a repl should be discarded or not
        scratch_repl = true,
        -- Your repl definitions come here
        repl_definition = {
          sh = {
            -- Can be a table or a function that
            -- returns a table (see below)
            command = {"zsh"}
          },
          python = {
            command = { "python3" },  -- or { "ipython", "--no-autoindent" }
            format = common.bracketed_paste_python,
            block_dividers = { "# %%", "#%%" },
          }
        },
        -- set the file type of the newly created repl to ft
        -- bufnr is the buffer id of the REPL and ft is the filetype of the 
        -- language being used for the REPL. 
        repl_filetype = function(bufnr, ft)
          return ft
          -- or return a string name such as the following
          -- return "iron"
        end,
        -- How the repl window will be displayed
        -- See below for more information
        repl_open_cmd = view.split.vertical.botright(0.5)

        -- repl_open_cmd can also be an array-style table so that multiple 
        -- repl_open_commands can be given.
        -- When repl_open_cmd is given as a table, the first command given will
        -- be the command that `IronRepl` initially toggles.
        -- Moreover, when repl_open_cmd is a table, each key will automatically
        -- be available as a keymap (see `keymaps` below) with the names 
        -- toggle_repl_with_cmd_1, ..., toggle_repl_with_cmd_k
        -- For example,
        -- 
        -- repl_open_cmd = {
        --   view.split.vertical.rightbelow("%40"), -- cmd_1: open a repl to the right
        --   view.split.rightbelow("%25")  -- cmd_2: open a repl below
        -- }

      },
      -- Iron doesn't set keymaps by default anymore.
      -- You can set them here or manually add keymaps to the functions in iron.core
      keymaps = {
        toggle_repl = "<space>rr", -- toggles the repl open and closed.
        -- If repl_open_command is a table as above, then the following keymaps are
        -- available
        -- toggle_repl_with_cmd_1 = "<space>rv",
        -- toggle_repl_with_cmd_2 = "<space>rh",
        restart_repl = "<space>rR", -- calls `IronRestart` to restart the repl
        send_motion = "<space>sc",
        visual_send = "<space>sc",
        send_file = "<space>sf",
        send_line = "<space>sl",
        send_paragraph = "<space>sp",
        send_until_cursor = "<space>su",
        send_mark = "<space>sm",
        send_code_block = "<space>sb",
        send_code_block_and_move = "<space>sn",
        mark_motion = "<space>mc",
        mark_visual = "<space>mc",
        remove_mark = "<space>md",
        cr = "<space>s<cr>",
        interrupt = "<space>s<space>",
        exit = "<space>sq",
        clear = "<space>cl",
      },
      -- If the highlight is on, you can change how it looks
      -- For the available options, check nvim_set_hl
      highlight = {
        italic = true
      },
      ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
    }

    -- ライン送信後にノーマルモードへ戻す
    local function send_line_and_exit_insert()
      iron.send_line()
      vim.cmd("stopinsert")
    end

    -- 選択範囲送信後にノーマルモードへ戻す
    local function visual_send_and_exit_insert()
      iron.visual_send()
      vim.cmd("stopinsert")
    end

    -- ファイル送信後にノーマルモードへ戻す
    local function send_file_and_exit_insert()
      iron.send_file()
      vim.cmd("stopinsert")
    end

    -- キーマップ設定
    vim.keymap.set("n", "<C-j>", send_line_and_exit_insert, {desc = "Send line and exit insert"})
    vim.keymap.set("n", "<C-J>", send_file_and_exit_insert, {desc = "Send file and exit insert"})
    vim.keymap.set("v", "<C-j>", visual_send_and_exit_insert, {desc = "Send selection and exit insert"})
  end,
})


-- colorscheme

require('onedark').setup {
	style = 'darker',
}
require('onedark').load()

-- coc

-- vim.cmd("autocmd CursorHold *.{ts,c,cpp,hpp,hs,py} if (coc#rpc#ready() && CocHasProvider('hover') && !coc#float#has_float()) | silent call CocActionAsync('doHover') | endif")
-- vim.cmd("autocmd CursorHold * silent call CocActionAsync('highlight')")

-- coc のフォーマットを使用する
-- keymap('n', '=', '<Plug>(coc-format-selected)', opts);
-- keymap('n', '==', 'gg<Plug>(coc-format-selected)G<C-o>zz', opts);

-- keymap('n', '<C-/', ':CocCommand explorer<CR>', opts)
keymap('n', 'gd', '<Plug>(coc-definition)', opts)
keymap('n', 'gy', '<Plug>(coc-type-definition)', opts)
keymap('n', 'gi', '<Plug>(coc-implementation)', opts)
keymap('n', 'gr', '<Plug>(coc-references)', opts)

keymap('n', '<D-.>', '<Plug>(coc-fix-current)', opts)
keymap('n', '<Space>.', '<Plug>(coc-fix-current)', opts)

keymap('n', '<F2>', '<Plug>(coc-rename)', opts)
keymap('n', '<F8>', '<Plug>(coc-diagnostic-next)zz', opts);
keymap('n', '<F11>', 'yy:e! <C-r>0<CR>', opts);
keymap('n', '<F12>', '<Plug>(coc-definition)', opts)

keymap("n", "<C-p>", "<Plug>(coc-diagnostic-prev)zz", opts)
keymap("n", "<C-n>", "<Plug>(coc-diagnostic-next)zz", opts)

-- keymap('n', '<C-S-D>', ':CocDiagnostics<CR>', opts);
-- keymap('n', '<C-e>', ':CocCommand explorer<CR>', opts)

keymap('n', '<Space>d', ':CocDiagnostics<CR>', opts);
keymap('n', '<Space>e', ':CocCommand explorer<CR>', opts)

-- fern
-- keymap('n', '<C-e>', ':Fern . -reveal=% -drawer -toggle -width=40<CR>', opts)

-- keymap('n', '<C-s>', ':vs tmp<CR>:r! grep -Ril ', opts);


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

-- disable copilot
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.defer_fn(function()
      vim.cmd('Copilot disable')
    end, 1000)
  end,
})
