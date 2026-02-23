
function dump(o, indent)
  local str = ''

  indent = indent or ""
  if type(o) == "table" then
    for k, v in pairs(o) do
      local key = string.format("%s[%s] = ", indent, tostring(k))
      if type(v) == "table" then
        str = str .. key .. "{" .. dump(v, indent .. " ") .. "}"
        -- print(key .. "{")
        -- dump(v, indent .. "  ")
        -- print(indent .. "}")
      else
        str = str .. key .. tostring(v)
        --print(key .. tostring(v))
      end
    end
  else
    str = str .. indent .. tostring(o)
    -- print(indent .. tostring(o))
  end

  return str
end

-- 文字列を区切り文字で分割する
function split(str, sep)
  local t = {}

  if sep == nil then
    -- 省略時はスペース
    sep = "%S+"
  end

  for word in str:gmatch(sep) do
    table.insert(t, word)
  end

  return t
end

function split(str)
    local t = {}
    for s in str:gmatch("%S+") do
        t[#t+1] = s
    end
    return t
end

local str = 'npm run api test -- --'
local result = split(str)

-- print(result)
-- dump(result)

local s = ''
s = s .. 'hogw' .. '\n'
s = s .. 'hogw' .. '\n'
s = s .. 'hogw' .. '\n'
print(s)
