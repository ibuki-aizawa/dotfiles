local vim = vim;

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
