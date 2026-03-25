local conform = require("conform")

conform.setup({
  formatters_by_ft = {
    -- Prettierで対応する言語を指定
    javascript = { "prettier" },
    typescript = { "prettier" },
    javascriptreact = { "prettier" },
    typescriptreact = { "prettier" },
    json = { "prettier" },
    html = { "prettier" },
    css = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
  },
  -- 保存時に自動フォーマットする設定
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true, -- Prettierがない場合はLSPのフォーマットを使う
  },
})
