local vim = vim;

local uex = require('utils.ex')
local edit = require('utils.edit')

vim.api.nvim_create_user_command(
  "ExecuteCommand",
  uex.execute_command,
  { nargs = "+", complete = "command" }
)

vim.api.nvim_create_user_command(
  "ExecuteCommandSplit",
  uex.execute_command_split,
  { nargs = "+", complete = "command" }
)

vim.api.nvim_create_user_command(
  "RipGrep",
  uex.RipGrep,
  { nargs = "+", complete = "command" }
)

vim.cmd([[
  cabbrev rg RipGrep
]])

-- ユーザーコマンド :Camel の登録
vim.api.nvim_create_user_command(
  'Camel',
  require('utils.string').to_camel_case,
  { range = true }
)

vim.cmd([[
  cabbrev : ExToBuffer
]])

-- Git
local git = require('utils.git')
vim.api.nvim_create_user_command('GitBlame', git.git_blame_current_buf, {})
vim.api.nvim_create_user_command('GitLog', git.git_log_current_file, {})
vim.api.nvim_create_user_command('GitShow', git.git_show_commit, { nargs = '?' })
vim.api.nvim_create_user_command('GitLog', git.git_log_current_file, {})
vim.api.nvim_create_user_command('GitShow', git.git_show_commit, { nargs = '?' })
vim.api.nvim_create_user_command('GitStatus', git.git_status_project, {})
vim.api.nvim_create_user_command('GitDiff', function() git.show_git_diff('current') end, {})
vim.api.nvim_create_user_command('GitDiffAll', function() git.show_git_diff('all') end, {})

vim.cmd([[
  cabbrev gd GitDiff
  cabbrev gda GitDiffAll
  cabbrev gb GitBlame
  cabbrev gs GitStatus
  cabbrev gl GitLog
  cabbrev gsh GitShow
]])

vim.api.nvim_create_user_command('Git', function(opts)
  vim.cmd('!git ' .. opts.args)
end, {
  nargs = '*',
  complete = 'shellcmd' -- ここを追加するとファイルパスなどの補完が効くようになります
})

vim.cmd([[
  cabbrev git Git
  cabbrev fetch Git fetch
  cabbrev pull Git pull
  cabbrev push Git push
  cabbrev gw Git switch
  cabbrev ga Git add
  cabbrev gc Git commit
]])

-- 直前のコマンド結果を現在のバッファに挿入する関数
vim.api.nvim_create_user_command('PutEx', function()
  local last_cmd = vim.fn.getreg(':')
  if last_cmd ~= "" then
    local output = vim.fn.execute(last_cmd)
    local lines = vim.split(output, "\n")
    vim.api.nvim_put(lines, "l", true, true)
  end
end, {})

-- 前回のExコマンドの結果を確認する
vim.api.nvim_create_user_command('ShowEx', function()
  -- 1. 直前のコマンドを取得
  local last_cmd = vim.fn.getreg(':')
  if last_cmd == "" then
    print("直前のコマンドが見つかりません")
    return
  end

  -- 2. コマンドを実行して結果を取得
  local output = vim.fn.execute(last_cmd)
  local lines = vim.split(output, "\n")

  -- 3. 新しいバッファを作成して設定
  vim.cmd('vnew') -- 垂直分割で新しいバッファを開く（水平なら 'new'）
  local buf = vim.api.nvim_get_current_buf()

  -- バッファの種類をスクラッチ（保存不要な一時ファイル）に設定
  vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'hide')
  vim.api.nvim_buf_set_option(buf, 'swapfile', false)

  -- 4. 結果をバッファに書き込む
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end, {})

-- 次の数字を検索してジャンプ
vim.api.nvim_create_user_command('SearchNumber', function()
  -- / は検索履歴に残るため、あえて履歴を汚さない search() 関数を使う手もありますが
  -- 'n' キーで次々飛びたいので、検索レジスタ (@/) を書き換える
  vim.fn.setreg('/', [[\d\+]])
  local status = pcall(vim.cmd, 'normal! n')
  if not status then
    print("数字は見つかりませんでした")
  end
end, { desc = "Search and jump to the next number" })

-- 関数（波カッコの塊）を行単位で検索して選択状態にする
vim.api.nvim_create_user_command('SelectFunctionObject', function(opts)
    -- ヴィジュアルモードから使用した場合を考慮し、強制終了してノーマルモードに戻る
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), 'n', true)

    -- 少し待機（モード切り替えを確実にするため）してから実行
    vim.schedule(function()
      local is_prev = (opts or {}).args == "prev"
      local search_op = is_prev and "?" or "/"
      local search_pattern = [[\v\{]]

      -- 一時的にラップスキャンをオフに
      local save_wrapscan = vim.opt.wrapscan:get()
      vim.opt.wrapscan = false

      -- 検索実行
      vim.fn.setreg('/', search_pattern)
      local status = pcall(vim.cmd, 'normal! ' .. search_op .. search_pattern .. "\13")

      vim.opt.wrapscan = save_wrapscan

      if status then
        vim.cmd('normal! va{Vo')
      else
        print("これより先にブロックはありません")
      end
    end)
end, {
  nargs = "?",
  desc = "Reset selection and jump to next block"
})

-- previous 版は、ヴィジュアルモード時の挙動が微妙
vim.api.nvim_create_user_command('SelectFunctionObjectPrevious', 'SelectFunctionObject prev', {})

vim.api.nvim_create_user_command('ToggleQuote', function(opts)
  local q = opts.args ~= "" and opts.args or "'"
  -- rangeが0（指定なし）ならカーソル行(.)を対象にする
  edit.toggle_quotes_in_range(opts.line1, opts.line2, q)
end, { range = true, nargs = '?' })
