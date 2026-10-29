local vim = vim;
local global = vim.g

-- vim.opt.fileencodings = { "ucs-bom", "utf-8", "utf-16", "cp932", "sjis", "euc-jp", "default" }

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

-- ファイル名として認める
vim.opt.isfname:append("[")
vim.opt.isfname:append("]")

-- gf で行番号付きのパスを解釈できるようにする
vim.opt.isfname:append(":")

-- colorscheme

-- require('onedark').setup {
-- 	style = 'darker',
-- }
-- require('onedark').load()
vim.cmd.colorscheme "catppuccin"
-- vim.cmd.colorscheme "catppuccin-frappe"
-- vim.cmd.colorscheme "habamax"
-- vim.cmd.colorscheme "xamabah"

-- vim.cmd("autocmd CursorHold *.{ts,c,cpp,hpp,hs,py} if (coc#rpc#ready() && CocHasProvider('hover') && !coc#float#has_float()) | silent call CocActionAsync('doHover') | endif")
-- vim.cmd("autocmd CursorHold * silent call CocActionAsync('highlight')")

-- コパイロット
-- global.copilot_no_tab_map = true

if vim.fn.has("win32") == 1 then
  -- PowerShell 7 (pwsh) があれば優先し、なければ Windows PowerShell を使用
  local powershell = vim.fn.executable("pwsh") == 1 and "pwsh" or "powershell"

  vim.o.shell = powershell
  -- -NoProfile を除外して $PROFILE (エイリアス設定等) を読み込ませる
  vim.o.shellcmdflag = "-NoLogo -ExecutionPolicy RemoteSigned -Command"
  vim.o.shellquote = ""
  vim.o.shellxquote = ""
end

