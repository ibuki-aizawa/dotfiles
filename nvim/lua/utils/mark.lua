local vim = vim;

local M = {}

local ns = vim.api.nvim_create_namespace("mark_signs")

local marks = {
  ".", "^", "\"", "'", "`", "[", "]", "<", ">"
}

for c = string.byte("a"), string.byte("z") do
  table.insert(marks, string.char(c))
end
for c = string.byte("A"), string.byte("Z") do
  table.insert(marks, string.char(c))
end
for c = string.byte("0"), string.byte("9") do
  table.insert(marks, string.char(c))
end

-- 行ごとにマークをまとめて表示
function M.update_marks(buf)
  if not buf or not vim.api.nvim_buf_is_valid(buf) or type(buf) ~= "number" then
    return
  end

  if vim.fn.bufwinid(buf) == -1 then
    return
  end

  local win = vim.api.nvim_get_current_win()
  if not vim.api.nvim_win_is_valid(win) then
    return
  end

  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

  local grouped = {}
  local last_line = vim.api.nvim_buf_line_count(buf) - 1

  for _, m in ipairs(marks) do
    local pos = vim.api.nvim_buf_get_mark(buf, m)
    if pos and pos[1] > 0 then
      local line = pos[1] - 1
      if line >= 0 and line <= last_line then
        grouped[line] = grouped[line] or {}
        table.insert(grouped[line], m)
      end
    end
  end

  -- 行ごとに extmark を置く
  local win_width = vim.api.nvim_win_get_width(0)
  local right_col_base = win_width - 6

  for line, ms in pairs(grouped) do
    local text = "<< " .. table.concat(ms, " ") .. " >>"
    local right_col = right_col_base - #text
    vim.api.nvim_buf_set_extmark(buf, ns, line, -1, {
      virt_text = { { text, "Folded" } },
      -- virt_text_pos = "eol",
      virt_text_win_col = right_col
    })
  end
end

return M
