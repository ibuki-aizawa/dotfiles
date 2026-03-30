local vim = vim;

local ft = require('ft.typescript')

-- コマンド登録
vim.api.nvim_create_user_command('Jest', ft.run_jest_realtime, {})

-- エイリアス（小文字でサクッと）
-- vim.cmd([[ cabbrev jt Jest ]])
vim.cmd([[ cabbrev jest Jest ]])
vim.cmd([[ cabbrev test Jest ]])

-- テストファイルに切り替える
vim.api.nvim_create_user_command(
  'SwitchTestFile',
  function ()
    local file = vim.fn.expand('%:p')
    if file:match('%.spec%.ts$') then
      file = vim.fn.expand('%:p:r:r') .. ".ts"
    else
      file = vim.fn.expand('%:p:r') .. ".spec.ts"
    end
    vim.cmd('e' .. file)
  end,
  {}
);

vim.api.nvim_create_user_command('Npm', function(opts)
  vim.cmd('!npm ' .. opts.args)
end, {
  nargs = '*',
  complete = 'shellcmd' -- ここを追加するとファイルパスなどの補完が効くようになります
})

vim.cmd([[
  cabbrev npm Npm
  cabbrev nr Npm run
]])
