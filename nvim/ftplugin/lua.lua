local vim = vim;
local table = require('utils.table')

local buf = {}

local function flash()
  print(table.to_string(buf))
  buf = {}
end

local function show_result(chan_id, data, name)
  buf[chan_id] = data[1]
end

local function show_error(chan_id, data, name)
  --local buf = ''
  --print(table.to_string(data))
  print('error!')
  --buf = buf .. chan_id .. " "
  --buf = buf .. name .. " "
  --buf = buf .. data[0] .. " "
  --for i = 0, #data do
  --  buf = buf .. data[i] .. " "
  --end
  --print(buf)
  --print(#data)
end

local function run()
  local c = { "ls", "-l" }
  --print(table.join(c, " "))
  vim.fn.jobstart(
    --table.join(c, ' '),
    'ls',
    {
      on_stdout = show_result,
      --on_stderr = show_error,
      on_exit = flash,
    }
  )
end

vim.api.nvim_create_user_command(
  'Run',
  run,
  {}
)
