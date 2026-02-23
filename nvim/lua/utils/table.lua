local M = {}

-- 配列を結合して文字列にする
function M.join(arr, ch)
  if ch == nil then
    ch = ' '
  end

  local str = ''

  for k, v in pairs(arr) do
    if v == nil then
      goto skip
    end

    str = str .. tostring(v)
    if k < #arr then
      str = str .. ch
    end

    ::skip::
  end

  return str
end

-- テーブルを文字列に変換する
function M.to_string(t, indent)
  local str = ''

  for k, v in pairs(t) do
    str = str .. k .. ': ' .. v .. '\n'
  end

  --indent = indent or ""
  --if type(o) == "table" then
  --  for k, v in pairs(o) do
  --    local key = string.format("%s[%s] = ", indent, tostring(k))
  --    if type(v) == "table" then
  --      str = str .. key .. "{" .. M.dump(v, indent .. " ") .. indent .. "}"
  --    else
  --      str = str .. key .. tostring(v)
  --    end
  --  end
  --else
  --  str = str .. indent .. tostring(o)
  --end

  return str
end

return M
