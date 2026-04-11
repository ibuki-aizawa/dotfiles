
require"nvim-treesitter.configs".setup {
  ensure_installed = { "prisma", "lua", "vim", "typescript" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
local status, configs = pcall(require, "nvim-treesitter.configs")
if not status then
    -- もし configs がダメな時だけ config を試す
    configs = require("nvim-treesitter.config")
end

configs.setup {
  -- インストールしたいパーサーを指定 (例: "lua", "python", "javascript" など)
  -- 全て入れたい場合は "all" ですが、最初は "maintained" や個別指定が推奨されます
  ensure_installed = {
    "lua",
    "vim",
    "vimdoc",
    "query",
    "javascript",
    -- "javascriptreact",
    "typescript",
    -- "typescriptreact",
    "prisma",
    "markdown",
    "markdown_inline"
  },

  -- 自動インストールを有効にするか
  auto_install = true,

  -- ハイライト機能の有効化
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
  },

  -- インデント機能の有効化（実験的）
  indent = {
    enable = true
  }
}
