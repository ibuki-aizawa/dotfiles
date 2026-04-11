local M = {}


function M.toggle_quotes_in_range(line1, line2, quote_char)
  quote_char = quote_char or "'"
  local lines = vim.api.nvim_buf_get_lines(0, line1 - 1, line2, false)
  local new_lines = {}

  for _, line in ipairs(lines) do
    local new_line
    -- パターン1: 引用符に囲まれた数値を解除 (例: '123' -> 123)
    -- すべての引用符付き数値を一括で置換
    local unquoted, count = line:gsub("(['\"])(%d+%.?%d*)%1", "%2")

    if count > 0 then
      -- 1つでも解除されたなら、その行は「解除モード」として採用
      new_line = unquoted
    else
      -- 1つも解除されなかったなら「囲みモード」
      -- 前後に数字・小数点・引用符がない「独立した数値」をすべて囲む
      new_line = line:gsub("([^'\"%d%.]?)(%d+%.?%d*)([^'\"%d%.]?)", function(before, num, after)
        return before .. quote_char .. num .. quote_char .. after
      end)
    end
    table.insert(new_lines, new_line)
  end

  vim.api.nvim_buf_set_lines(0, line1 - 1, line2, false, new_lines)
end

return M
