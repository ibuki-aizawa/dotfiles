local vim = vim;

local mark = require('utils.mark')

-- ターミナルをインサートモードで開く
vim.cmd('autocmd TermOpen * startinsert')

-- 起動時に反映
vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function(ev)
    mark.update_marks(ev.buf)
  end,
})

-- カーソル移動時に更新
vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
  callback = function()
    mark.update_marks(vim.api.nvim_get_current_buf())
  end,
})
