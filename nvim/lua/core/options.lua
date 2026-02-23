local vim = vim;
local global = vim.g

-- use rg for external-grep
vim.opt.grepprg = table.concat({
  'rg',
  '--vimgrep',
  '--trim',
  '--hidden',
  [[--glob='!.git']],
  [[--glob='!*.lock']],
  [[--glob='!*-lock.json']],
  [[--glob='!*generated*']],
  -- [[--glob='!openapi.yaml']],
  -- [[--glob='!**.spec.ts']],
}, ' ')
vim.opt.grepformat = '%f:%l:%c:%m'

-- colorscheme

-- require('onedark').setup {
-- 	style = 'darker',
-- }
-- require('onedark').load()
vim.cmd.colorscheme "catppuccin"
-- vim.cmd.colorscheme "habamax"
-- vim.cmd.colorscheme "xamabah"

-- vim.cmd("autocmd CursorHold *.{ts,c,cpp,hpp,hs,py} if (coc#rpc#ready() && CocHasProvider('hover') && !coc#float#has_float()) | silent call CocActionAsync('doHover') | endif")
-- vim.cmd("autocmd CursorHold * silent call CocActionAsync('highlight')")

-- コパイロット
global.copilot_no_tab_map = true

