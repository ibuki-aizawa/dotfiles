local vim = vim;

local M = {}

function M.run_jest_realtime()
  local path = vim.api.nvim_buf_get_name(0)

  local src_buf = vim.api.nvim_get_current_buf()
  local file = vim.fn.expand('%:p')
  if not file:match('%.spec%.ts$') then
    file = vim.fn.expand('%:p:r') .. ".spec.ts"
  end

  local buf_name = "JEST_RESULT"
  local test_buf = vim.fn.bufnr(buf_name)

  -- バッファの作成または再利用
  if test_buf == -1 then
    vim.cmd('vnew')
    vim.cmd('file ' .. buf_name)
    test_buf = vim.api.nvim_get_current_buf()
  else
    local winid = vim.fn.bufwinid(test_buf)
    if winid == -1 then
      vim.cmd('vsplit | b' .. test_buf)
    else
      vim.fn.win_gotoid(winid)
    end
  end

  -- 設定と初期化（前回の内容を消去）
  vim.cmd('setlocal buftype=nofile bufhidden=hide noswapfile filetype=sh')
  vim.api.nvim_buf_set_lines(test_buf, 0, -1, false, { "🚀 Running: " .. file, "" })

  -- 連動して閉じる設定
  vim.api.nvim_create_autocmd("BufWipeout", {
    buffer = src_buf,
    once = true,
    callback = function()
      if vim.api.nvim_buf_is_valid(test_buf) then
        vim.api.nvim_buf_delete(test_buf, { force = true })
      end
    end,
  })

  local command
  if path:match("/api/") then
    command = { "npm", "run", "api", "test", "--", "--", "--no-colors", file }
  elseif path:match("/web/") then
    command = { "npm", "run", "web", "test", "--", "--", "--no-colors", file }
  else
    command = { "npm", "run", "test", "--", "--no-colors", file }
  end

  -- 非同期実行（リアルタイム・ストリーミング）
  vim.fn.jobstart(command, {
    -- ここを false にするのが肝！
    stdout_buffered = false,
    stderr_buffered = false,
    on_stdout = function(_, data)
      if data and ( #data > 1 or data[1] ~= "" ) then
        vim.api.nvim_buf_set_lines(test_buf, -1, -1, false, data)
        -- 常に最新の行にスクロール
        local line_count = vim.api.nvim_buf_line_count(test_buf)
        vim.api.nvim_win_set_cursor(vim.fn.bufwinid(test_buf), {line_count, 0})
      end
    end,
    on_stderr = function(_, data)
      if data and ( #data > 1 or data[1] ~= "" ) then
        vim.api.nvim_buf_set_lines(test_buf, -1, -1, false, data)
        -- 常に最新の行にスクロール
        local line_count = vim.api.nvim_buf_line_count(test_buf)
        vim.api.nvim_win_set_cursor(vim.fn.bufwinid(test_buf), {line_count, 0})
      end
    end,
    on_exit = function()
      vim.api.nvim_buf_set_lines(test_buf, -1, -1, false, { "", "✅ Finished!" })
    end,
  })

  -- コード側にフォーカスを戻す
  vim.cmd('wincmd p')
  vim.keymap.set('n', 'q', ':bd<CR>', { buffer = test_buf, silent = true })
end

return M
