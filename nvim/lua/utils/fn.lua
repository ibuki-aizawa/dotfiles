local vim = vim;
local M = {}

function M.command_to_buffer(opts)
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

return M
