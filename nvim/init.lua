local vim = vim;
local global = vim.g

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
keymap('n', '<D-s>', ':wa<CR>', opts);
keymap('n', '<D-w>', ':qa<CR>', opts);

keymap('n', 'n', 'nzz', opts);
keymap('n', 'N', 'Nzz', opts);
keymap('n', '*', '*zz', opts);

-- コマンドラインで %% と打つと、今のファイルがあるディレクトリに置換する
vim.keymap.set('c', '%%', "getcmdtype() == ':' ? expand('%:h') . '/' : '%%'", { expr = true })

-- %: : ディレクトリ + 今のファイル名
-- これで :e %: と打つと "path/to/current_file.lua" が展開される
vim.keymap.set('c', '%:', "getcmdtype() == ':' ? expand('%:p') : '%:'", { expr = true })

-- %. : 拡張子抜きのフルパス (例: main.lua -> main)
-- 「main_spec.lua」などを隣に作りたい時に便利！
vim.keymap.set('c', '%.', "getcmdtype() == ':' ? expand('%:p:r') : '%.'", { expr = true })

-- %t : ファイル名だけ (例: path/to/login.ts -> login.ts)
vim.keymap.set('c', '%t', "getcmdtype() == ':' ? expand('%:t') : '%t'", { expr = true })

-- %h : ファイル名だけ（拡張子なし） (例: login.ts -> login)
vim.keymap.set('c', '%h', "getcmdtype() == ':' ? expand('%:t:r') : '%h'", { expr = true })

-- keymap('n', 'gj', '15jzz', opts);
-- keymap('n', 'gk', '15kzz', opts);
-- keymap('n', 'gl', '15lzz', opts);
-- keymap('n', 'gh', '15hzz', opts);

-- ウィンドウ切り替え
-- keymap('n', '<C-h>', '<C-w>h', opts);
-- keymap('n', '<C-k>', '<C-w>k', opts);
-- keymap('n', '<C-l>', '<C-w>l', opts);

-- ターミナル表示
-- keymap('n', '<Space>;', ':split<CR>:term<CR><C-\\><C-n>:resize 15<CR>i', opts);
-- keymap('n', '<C-;>', ':split<CR>:term<CR><C-\\><C-n>:resize 15<CR>i', opts);

-- keymap('n', 'gt', ':vs<CR><C-w>l<CR>:term<CR>', opts);

-- ターミナルからスムーズにウィンドウ切り替えできるように
keymap('t', '<C-w>', '<C-\\><C-n><C-w>', opts);

-- ターミナル終了
-- keymap('t', '<C-;>', '<C-\\>exit<CR>', opts);

local function run_jest_current()
  -- 現在のファイルが .spec.ts かどうかを確認（あるいはそのまま実行）
  local file = vim.fn.expand('%:p')

  -- 実行するコマンド（npx jest パス）
  -- 別のバッファで結果を見たいので、新しいタブか分割で開くのがおすすめ
  vim.cmd('vnew') -- 縦分割で新しいバッファを作成
  vim.cmd('setlocal buftype=nofile bufhidden=wipe noswapfile filetype=sh')

  -- テスト実行。npx jest にフルパスを渡す
  -- append(0, ...) でバッファの先頭に結果を書き込む
  local cmd = "npx jest " .. file
  -- local cmd = "npm run api test -- -- " .. file
  vim.fn.append(0, "Running: " .. cmd)
  vim.cmd('r !' .. cmd)

  -- 'q' で結果バッファを閉じれるようにする
  vim.keymap.set('n', 'q', ':bd<CR>', { buffer = true, silent = true })
  vim.cmd('normal! gg')
end

local function run_jest_async()
  local file = vim.fn.expand('%:p')

  -- 本体ファイルなら対応する spec を、そうでなければそのまま実行
  if not file:match('%.spec%.ts$') then
    file = vim.fn.expand('%:p:r') .. ".spec.ts"
  end

  -- 出力用のバッファを作成
  vim.cmd('vnew')
  local bufnr = vim.api.nvim_get_current_buf()
  vim.cmd('setlocal buftype=nofile bufhidden=wipe noswapfile filetype=sh')
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "🚀 Running Jest (async)...", "" })

  -- Jestの結果バッファに対してだけ有効にする
  vim.cmd([[
    syntax match JestPass /PASS/
    syntax match JestFail /FAIL/
    highlight JestPass guifg=#98c379 gui=bold
    highlight JestFail guifg=#e06c75 gui=bold
  ]])

  -- 非同期で実行開始
  -- vim.fn.jobstart({ "npx", "jest", "--color", file }, {
  vim.fn.jobstart({ "npm", "run", "api", "test", "--", "--", "--no-colors", file }, {
    env = { NO_COLOR = "1" },
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data then
        vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
      end
    end,
    on_stderr = function(_, data)
      if data then
        vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
      end
    end,
    on_exit = function()
      vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, { "", "✅ Finished!" })
      -- 終わったことがわかるように、自動的に末尾へスクロール（任意）
      vim.cmd('normal! G')
    end,
  })

  -- 元のウィンドウ（コード側）に一瞬で戻る
  vim.cmd('wincmd p')

  -- 'q' で閉じれるように設定
  vim.keymap.set('n', 'q', ':bd<CR>', { buffer = bufnr, silent = true })
end

-- 関数の中身をこれに差し替えると、より柔軟になります
local function run_jest_smart()
    local file = vim.fn.expand('%:p')

    -- もし .spec.ts じゃないファイルなら、対応する .spec.ts を探す
    if not file:match('%.spec%.ts$') then
        file = vim.fn.expand('%:p:r') .. ".spec.ts"
    end

    vim.cmd('vnew | setlocal buftype=nofile bufhidden=wipe noswapfile')
    -- vim.cmd('r !npx jest ' .. file)
    vim.cmd('r !npm run api test -- -- ' .. file)
    vim.keymap.set('n', 'q', ':bd<CR>', { buffer = true, silent = true })
end

-- コマンド登録
vim.api.nvim_create_user_command('Jest', run_jest_current, {})
vim.api.nvim_create_user_command('JestSmart', run_jest_smart, {})
vim.api.nvim_create_user_command('JestAsync', run_jest_async, {})


-- エイリアス（小文字でサクッと）
-- vim.cmd([[ cabbrev jt Jest ]])
vim.cmd([[ cabbrev jt JestAsync ]])

-- git blame 表示関数 色付き版
local function git_blame_current_buf()
  local path = vim.fn.expand('%:p')
  local current_line = vim.fn.line('.')

  vim.cmd('enew')
  vim.cmd('setlocal buftype=nofile bufhidden=wipe noswapfile')

  -- git blame を読み込み
  vim.cmd('r !git blame ' .. vim.fn.shellescape(path))
  vim.cmd('1delete')

  -- ★ ここから色付け（Syntaxハイライト）の設定 ★
  -- 1. ハッシュ（先頭の8文字くらい）を特定の色に
  vim.cmd('syntax match BlameHash /^\\^\\?\\x\\+/')
  vim.cmd('highlight default link BlameHash Statement') -- 黄色/オレンジ系

  -- 2. 作者名（カッコの中の最初の部分）を特定の色に
  vim.cmd('syntax match BlameUser /([^)]\\+)/')
  vim.cmd('highlight default link BlameUser Type') -- 緑/水色系

  -- 3. 日付（202x-xx-xx 形式）を特定の色に
  vim.cmd('syntax match BlameDate /\\d\\{4}-\\d\\{2}-\\d\\{2}/')
  vim.cmd('highlight default link BlameDate Comment') -- グレー/青系
  -- ★ ここまで ★

  vim.api.nvim_win_set_cursor(0, {current_line, 0})
  vim.cmd('normal! zz')
  vim.keymap.set('n', 'q', ':bd<CR>', { buffer = true, silent = true })
end

-- vim.keymap.set('n', 'gb', git_blame_current_buf, { desc = 'Git Blame (Short)' })
-- vim.keymap.set('n', '<Leader>gb', git_blame_current_buf, { desc = 'Git Blame (Leader)' })
vim.api.nvim_create_user_command('GitBlame', function() git_blame_current_buf() end, {})

-- Git Diff を表示する共通コア関数
local function show_git_diff(scope)
  local cmd = 'git diff'
  if scope == 'current' then
    cmd = cmd .. ' ' .. vim.fn.shellescape(vim.fn.expand('%:p'))
  end

  vim.cmd('enew')
  vim.cmd('setlocal buftype=nofile bufhidden=wipe noswapfile filetype=diff')

  -- 外部コマンド実行（エラーハンドリング込）
  local output = vim.fn.system(cmd)
  if output == "" then
    print("No changes found.")
    vim.cmd('bd') -- 差分がなければ閉じる
    return
  end

  -- バッファに内容をセット
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(output, '\n'))

  -- 仕上げ
  vim.keymap.set('n', 'q', ':bd<CR>', { buffer = true, silent = true })
  vim.cmd('normal! gg')
end

-- カレントバッファ版
vim.api.nvim_create_user_command('GitDiff', function() show_git_diff('current') end, {})
-- 全体版
vim.api.nvim_create_user_command('GitDiffAll', function() show_git_diff('all') end, {})

-- git status を表示する関数
local function git_status_project()
  vim.cmd('enew')

  -- bufhidden=hide に変更（前回の気づきを反映！）
  vim.cmd('setlocal buftype=nofile bufhidden=hide noswapfile filetype=gitcommit')

  -- git status を実行
  vim.cmd('r !git status')
  vim.cmd('1delete')

  -- ★ 1. ファイル名に色をつける (Syntaxハイライト)
  -- modified: などの後のファイル名を「Directory(青系)」や「String(緑系)」で目立たせる
  vim.cmd([[
  syntax match GitStatusModified /modified: \+.\+/
  syntax match GitStatusNew /new file: \+.\+/
  syntax match GitStatusFile /.\+$/ containedin=GitStatusModified,GitStatusNew contained

  highlight default link GitStatusModified Comment
  highlight default link GitStatusFile Directory
  highlight default link GitStatusNew Special
  ]])

  -- ★ 2. 初期カーソル位置を最初の modified ファイルへ移動
  -- "/modified:" で検索して、その2単語先（ファイル名）にジャンプ
  local success = pcall(function()
    vim.cmd([[ /modified:/ ]])
    vim.cmd([[ normal! f:3l ]]) -- "modified:" の次の単語(ファイル名)へ移動
  end)

  -- ハイライトを消す
  vim.cmd('nohlsearch')

  -- modified がなかった場合は先頭へ
  if not success then
    vim.cmd('normal! gg')
  end

  vim.keymap.set('n', 'q', ':bd<CR>', { buffer = true, silent = true })
end

-- コマンド登録
vim.api.nvim_create_user_command('GitStatus', git_status_project, {})

-- Lua から Vim script のコマンドを実行する
vim.cmd([[
  cabbrev gd GitDiff
  cabbrev gda GitDiffAll
  cabbrev gb GitBlame
  cabbrev gs GitStatus
]])

-- https://github.com/junegunn/vim-plug
local Plug = vim.fn['plug#'];

-- plug
vim.call('plug#begin')

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
        -- exit = "<C-h>",
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
    vim.keymap.set("n", "<Space>r", send_line_and_exit_insert, {desc = "Send line and exit insert"})
    vim.keymap.set("n", "<F5>", send_file_and_exit_insert, {desc = "Send file and exit insert"})
    vim.keymap.set("v", "<Space>r", visual_send_and_exit_insert, {desc = "Send selection and exit insert"})
  end,
})


-- colorscheme

--require('onedark').setup {
--	style = 'darker',
--}
--require('onedark').load()
vim.cmd.colorscheme "catppuccin"

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

keymap('n', '<C-.>', '<Plug>(coc-fix-current)', opts)
keymap('n', '<D-.>', '<Plug>(coc-fix-current)', opts)

keymap('n', '<F2>', '<Plug>(coc-rename)', opts)
keymap('n', '<F8>', '<Plug>(coc-diagnostic-next)zz', opts);
-- keymap('n', '<F11>', 'yy:e! <C-r>0<CR>', opts);
keymap('n', '<F12>', '<Plug>(coc-definition)', opts)

keymap("n", "[e", "<Plug>(coc-diagnostic-prev)zz", opts)
keymap("n", "]e", "<Plug>(coc-diagnostic-next)zz", opts)

-- keymap("n", "<Space>[", "<Plug>(coc-diagnostic-prev)zz", opts)
-- keymap("n", "<Space>]", "<Plug>(coc-diagnostic-next)zz", opts)

keymap("n", "<C-p>", "<Plug>(coc-diagnostic-prev)zz", opts)
keymap("n", "<C-n>", "<Plug>(coc-diagnostic-next)zz", opts)

-- keymap('n', '<C-S-D>', ':CocDiagnostics<CR>', opts);
-- keymap('n', '<C-e>', ':CocCommand explorer<CR>', opts)

keymap('n', '<Space>.', '<Plug>(coc-fix-current)', opts)

-- エクスプローラー
keymap('n', '<Space>e', ':CocCommand explorer<CR>', opts)

-- エラー一覧
keymap('n', '<Space>d', ':CocDiagnostics<CR>', opts);
keymap('n', 'ge', ':CocDiagnostics<CR>', opts);

-- keymap('n', '<Space>f', ':CocList grep<CR>', opts)

keymap('n', '<Space>w', ':wa<CR>', opts);
keymap('n', '<Space>q', ':q<CR>', opts);
keymap('n', '<Space>wq', ':wa<CR>:qa<CR>', opts);

-- fzf.vim

-- keymap('n', '<Space><Space>', ':Files<CR>', opts)
keymap('n', '<Space>ff', ':Files<CR>', opts)
keymap('n', '<Space>fb', ':Buffer<CR>', opts)
keymap('n', '<Space>fl', ':Lines<CR>', opts)
keymap('n', '<Space>fr', ':Rg<CR>', opts)
-- keymap('n', '<Space>fg', ':Rg<CR>', opts)
keymap('n', '<Space>fj', ':Jumps<CR>', opts)
keymap('n', '<Space>fw', ':Windows<CR>', opts)
keymap('n', '<Space>fh', ':History<CR>', opts)
keymap('n', '<Space>fm', ':Marks<CR>', opts)
keymap('n', '<Space>fc', ':Commands<CR>', opts)

keymap('n', '<Space>bf', ':Buffer<CR>', opts)
keymap('n', '<Space>bl', ':BLines<CR>', opts)
keymap('n', '<Space>bt', ':BTags<CR>', opts)
keymap('n', '<Space>bm', ':BMarks<CR>', opts)
keymap('n', '<Space>bc', ':BCommands<CR>', opts)

keymap('n', '<Space>gf', ':GFiles<CR>', opts)
keymap('n', '<Space>fg', ':GFiles<CR>', opts)

-- 設定ファイル
-- keymap('n', '<Space>?', ':tabnew ~/.config/nvim/init.lua<CR>', opts);
-- keymap('n', '<Space>r', ':so ~/.config/nvim/init.lua<CR>', opts);


-- コパイロット
keymap('i', '<C-j>', 'copilot#Accept(\"<CR>\")', {expr = true, silent = true, script = true})
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
