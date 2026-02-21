local vim = vim;

local M = {}

-- キャメルケース変換関数
function M.to_camel_case()
  -- ビジュアルモードの開始点と終了点を取得
  -- table.unpack を使用
  local _unpack = table.unpack or unpack
  local _, s_row, s_col, _ = _unpack(vim.fn.getpos("'<"))
  local _, e_row, e_col, _ = _unpack(vim.fn.getpos("'>"))

  -- 選択範囲のテキストを取得
  local lines = vim.api.nvim_buf_get_text(0, s_row - 1, s_col - 1, e_row - 1, e_col, {})
  if #lines == 0 then return end

  -- 文字列を結合して変換 (snake_case -> camelCase)
  local text = table.concat(lines, "\n")
  local camel = text:gsub("(_)([a-z])", function(_, l)
    return l:upper()
  end)

  -- バッファに書き戻し
  vim.api.nvim_buf_set_text(0, s_row - 1, s_col - 1, e_row - 1, e_col, { camel })
end

return M
