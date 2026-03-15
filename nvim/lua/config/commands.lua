local vim = vim;

local uex = require('utils.ex')

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
