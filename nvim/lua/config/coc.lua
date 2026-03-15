local vim = vim;

vim.g.coc_global_extensions = {
  "coc-git",
  "coc-json",
  "coc-lua",
  "coc-tsserver",
  "coc-explorer",
  "coc-pyright",
  "coc-rust-analyzer",
  "coc-pairs",
  "coc-lists",
}

local config = vim.fn.stdpath("config") .. "/coc.vim"
vim.cmd("source " .. config)
