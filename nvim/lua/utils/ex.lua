local vim = vim;
local M = {}

function M.execute_command(opts)
  local cmd = opts.args
  if cmd == "" then
    print("EX コマンドを指定してください")
    return
  end

  -- EX コマンドを実行して結果を取得
  local result = vim.api.nvim_exec2(cmd, { output = true }).output

  -- 新しいバッファを作成
  local buf = vim.api.nvim_create_buf(true, true)

  -- 出力を行単位にしてバッファへ書き込む
  local lines = {}
  for line in result:gmatch("([^\n]*)\n?") do
    table.insert(lines, line)
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- バッファを現在のウィンドウに表示
  vim.api.nvim_set_current_buf(buf)
end

function M.execute_command_split(opts)
  local cmd = opts.args
  if cmd == "" then
    print("EX コマンドを指定してください")
    return
  end

  local result = vim.api.nvim_exec2(cmd, { output = true }).output

  local buf_name = "SPLIT_COMMAND"
  local buf = vim.fn.bufnr(buf_name)

  if buf == -1 then
    vim.cmd('vnew')
    vim.cmd('file ' .. buf_name)
    buf = vim.api.nvim_get_current_buf()
  else
    local winid = vim.fn.bufwinid(buf)
    if winid == -1 then
      vim.cmd('vplit | b' .. buf)
    else
      vim.fn.win_gotoid(winid)
    end
  end

  -- 設定と初期化（前回の内容を消去）
  vim.cmd('setlocal buftype=nofile bufhidden=hide noswapfile filetype=sh')

  local lines = {}
  for line in result:gmatch("([^\n]*)\n?") do
    table.insert(lines, line)
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- 連動して閉じる設定
  vim.api.nvim_create_autocmd("BufWipeout", {
    buffer = buf,
    once = true,
    callback = function()
      if vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_delete(buf, { force = true })
      end
    end,
  })

  -- コード側にフォーカスを戻す
  vim.cmd('wincmd p')
  vim.keymap.set('n', 'q', ':bd<CR>', { buffer = buf, silent = true })
end

function M.RipGrep(opts)
  local search = opts.args
  if search == "" then
    print("検索条件を指定してください")
    return
  end

  -- EX コマンドを実行して結果を取得
  local result = vim.api.nvim_exec2('!rg --vimgrep ' .. search, { output = true }).output

  -- 新しいバッファを作成
  local buf = vim.api.nvim_create_buf(true, true)

  -- スペースなどが含まれても大丈夫なように名前を生成
  local buf_name = "rg " .. search
  -- 同名のバッファがあるとエラーになるのを防ぐため pcall で囲むか、一意にする
  pcall(vim.api.nvim_buf_set_name, buf, buf_name)

  -- 出力を行単位にしてバッファへ書き込む
  local lines = {}
  for line in result:gmatch("([^\n]*)\n?") do
    table.insert(lines, line)
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- バッファを現在のウィンドウに表示
  vim.api.nvim_set_current_buf(buf)
end

return M
