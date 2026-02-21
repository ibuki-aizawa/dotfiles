local vim = vim;

local ft = require('ft.typescript')

-- コマンド登録
-- vim.api.nvim_create_user_command('Jest', ft.run_jest_current, {})
-- vim.api.nvim_create_user_command('JestSmart', ft.run_jest_smart, {})
-- vim.api.nvim_create_user_command('JestAsync', ft.run_jest_async, {})
vim.api.nvim_create_user_command('Jest', ft.run_jest_realtime, {})

-- エイリアス（小文字でサクッと）
-- vim.cmd([[ cabbrev jt Jest ]])
vim.cmd([[ cabbrev jest Jest ]])
