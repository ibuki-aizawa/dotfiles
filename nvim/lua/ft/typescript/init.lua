local vim = vim;

local M = {}

-- function M.run_jest_current()
--   -- 現在のファイルが .spec.ts かどうかを確認（あるいはそのまま実行）
--   local file = vim.fn.expand('%:p')
-- 
--   -- 実行するコマンド（npx jest パス）
--   -- 別のバッファで結果を見たいので、新しいタブか分割で開くのがおすすめ
--   vim.cmd('vnew') -- 縦分割で新しいバッファを作成
--   vim.cmd('setlocal buftype=nofile bufhidden=wipe noswapfile filetype=sh')
-- 
--   -- テスト実行。npx jest にフルパスを渡す
--   -- append(0, ...) でバッファの先頭に結果を書き込む
--   local cmd = "npx jest " .. file
--   -- local cmd = "npm run api test -- -- " .. file
--   vim.fn.append(0, "Running: " .. cmd)
--   vim.cmd('r !' .. cmd)
-- 
--   -- 'q' で結果バッファを閉じれるようにする
--   vim.keymap.set('n', 'q', ':bd<CR>', { buffer = true, silent = true })
--   vim.cmd('normal! gg')
-- end
-- 
-- function M.run_jest_async()
--   local file = vim.fn.expand('%:p')
-- 
--   -- 本体ファイルなら対応する spec を、そうでなければそのまま実行
--   if not file:match('%.spec%.ts$') then
--     file = vim.fn.expand('%:p:r') .. ".spec.ts"
--   end
-- 
--   -- 出力用のバッファを作成
--   vim.cmd('vnew')
--   local bufnr = vim.api.nvim_get_current_buf()
--   vim.cmd('setlocal buftype=nofile bufhidden=wipe noswapfile filetype=sh')
--   vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "🚀 Running Jest (async)...", "" })
-- 
--   -- Jestの結果バッファに対してだけ有効にする
--   vim.cmd([[
--     syntax match JestPass /PASS/
--     syntax match JestFail /FAIL/
--     highlight JestPass guifg=#98c379 gui=bold
--     highlight JestFail guifg=#e06c75 gui=bold
--   ]])
-- 
--   -- 非同期で実行開始
--   -- vim.fn.jobstart({ "npx", "jest", "--color", file }, {
--   vim.fn.jobstart({ "npm", "run", "api", "test", "--", "--", "--no-colors", file }, {
--     env = { NO_COLOR = "1" },
--     stdout_buffered = false,
--     stderr_buffered = false,
--     on_stdout = function(_, data)
--       if data then
--         vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
--       end
--     end,
--     on_stderr = function(_, data)
--       if data then
--         vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
--       end
--     end,
--     on_exit = function()
--       vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, { "", "✅ Finished!" })
--       -- 終わったことがわかるように、自動的に末尾へスクロール（任意）
--       vim.cmd('normal! G')
--     end,
--   })
-- 
--   -- 元のウィンドウ（コード側）に一瞬で戻る
--   vim.cmd('wincmd p')
-- 
--   -- 'q' で閉じれるように設定
--   vim.keymap.set('n', 'q', ':bd<CR>', { buffer = bufnr, silent = true })
-- end

function M.run_jest_realtime()
  local src_buf = vim.api.nvim_get_current_buf()
  local file = vim.fn.expand('%:p')
  if not file:match('%.spec%.ts$') then
    file = vim.fn.expand('%:p:r') .. ".spec.ts"
  end

  local buf_name = "JEST_RESULT"
  local test_buf = vim.fn.bufnr(buf_name)

  -- 1. バッファの作成または再利用
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

  -- 2. 設定と初期化（前回の内容を消去）
  vim.cmd('setlocal buftype=nofile bufhidden=hide noswapfile filetype=sh')
  vim.api.nvim_buf_set_lines(test_buf, 0, -1, false, { "🚀 Running: " .. file, "" })

  -- 3. 連動して閉じる設定
  vim.api.nvim_create_autocmd("BufWipeout", {
    buffer = src_buf,
    once = true,
    callback = function()
      if vim.api.nvim_buf_is_valid(test_buf) then
        vim.api.nvim_buf_delete(test_buf, { force = true })
      end
    end,
  })

  -- 4. 非同期実行（リアルタイム・ストリーミング）
  -- vim.fn.jobstart({ "npx", "jest", "--no-colors", file }, {
  vim.fn.jobstart({ "npm", "run", "api", "test", "--", "--", "--no-colors", file }, {
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

  -- 5. コード側にフォーカスを戻す
  vim.cmd('wincmd p')
  vim.keymap.set('n', 'q', ':bd<CR>', { buffer = test_buf, silent = true })
end

-- 関数の中身をこれに差し替えると、より柔軟になります
-- function M.run_jest_smart()
--     local file = vim.fn.expand('%:p')
-- 
--     -- もし .spec.ts じゃないファイルなら、対応する .spec.ts を探す
--     if not file:match('%.spec%.ts$') then
--         file = vim.fn.expand('%:p:r') .. ".spec.ts"
--     end
-- 
--     vim.cmd('vnew | setlocal buftype=nofile bufhidden=wipe noswapfile')
--     -- vim.cmd('r !npx jest ' .. file)
--     vim.cmd('r !npm run api test -- -- ' .. file)
--     vim.keymap.set('n', 'q', ':bd<CR>', { buffer = true, silent = true })
-- end

return M
