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

