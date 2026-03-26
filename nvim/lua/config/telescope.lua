
require('telescope').setup({
  extensions = {
    fzf = {
      fuzzy = true,                    -- fuzzy searchを有効に
      override_generic_sorter = true,  -- 汎用ソーターを上書き
      override_file_sorter = true,     -- ファイルソーターを上書き
      case_mode = "smart_case",        -- 大文字小文字を賢く判定
    }
  }
})

require('telescope').load_extension('fzf')
