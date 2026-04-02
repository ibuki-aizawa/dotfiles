local vim = vim;

-- keymap
local opts = {
	noremap = true,
	silent = true,
}

local keymap = vim.api.nvim_set_keymap

-- コマンドモード展開
vim.keymap.set('c', '%%', "getcmdtype() == ':' ? expand('%') : '%%'", { expr = true })
vim.keymap.set('c', '%:p', "getcmdtype() == ':' ? expand('%:p') : '%:p'", { expr = true })
vim.keymap.set('c', '%:h', "getcmdtype() == ':' ? expand('%:h') . '/' : '%:h'", { expr = true })

-- ]n / [n で数字へジャンプ
-- vim.keymap.set('n', ']n', function() vim.fn.search([[\d\+]], 'W') end, { desc = "Next number" })
-- vim.keymap.set('n', '[n', function() vim.fn.search([[\d\+]], 'bW') end, { desc = "Prev number" })
vim.keymap.set('n', ']n', [[/\d\+<CR>]], { silent = true, desc = "Next number" })
vim.keymap.set('n', '[n', [[?\d\+<CR>]], { silent = true, desc = "Prev number" })

-- Tab でバッファ巡回
vim.keymap.set('n', '<Tab>', ':bn<CR>')
vim.keymap.set('n', '<S-Tab>', ':bp<CR>')

-- Tab でバッファ巡回
-- vim.keymap.set('n', '<C-Tab>', 'gt<CR>')
-- vim.keymap.set('n', '<C-S-Tab>', 'gt<CR>')

-- オペレータ待機モード (o) で、直前の変更範囲をターゲットにする
-- ターゲットにする範囲の定義
local motions = {
  { key = 'ic', mode = 'v', desc = '直前の変更範囲（文字）' },
  { key = 'iC', mode = 'V', desc = '直前の変更範囲（行）' },
  { key = 'C', mode = 'V', desc = '直前の変更範囲（行）' },
}

for _, m in ipairs(motions) do
  local cmd = string.format(':<C-u>normal! `[%s`]<CR>', m.mode)
  vim.keymap.set({'o', 'x'}, m.key, cmd, { silent = true, desc = m.desc })
end

vim.keymap.set("n", "gf", function()
  local cfile = vim.fn.expand("<cfile>")

  -- 1. まず、パスに ":" が含まれているか確認
  if string.find(cfile, ":") then
    -- ファイル名、行番号、列番号を分離 (例: file.ts:10:5)
    local file, line, col = string.match(cfile, "([^:]+):(%d+):?(%d*)")

    -- 分離した「ファイル名部分」が実際に存在するかチェック
    if file and vim.fn.filereadable(file) == 1 then
      vim.cmd("edit " .. file)
      local l = tonumber(line) or 1
      local c = tonumber(col) or 0
      -- 安全に行移動（存在しない行を指定してもエラーにならないよう pcall）
      pcall(vim.api.nvim_win_set_cursor, 0, {l, c})
      pcall(vim.cmd, "normal! zz")
      return
    end
  end

  -- 2. ":" が含まれない、またはファイルが見つからない場合は標準の gf を実行
  --  ok が false の場合はファイルが見つからないエラーを表示
  local ok = pcall(vim.cmd, "normal! gF") -- 'gF' は標準でファイル:行番号に対応している場合があるためこちらを試行
  if not ok then
      -- gF もダメなら通常の gf
      pcall(vim.cmd, "normal! gf")
  end
end, { desc = "Improved gf with line number support" })

-- emacs風のキーバインド

-- keymap('i', '<C-p>', '<Up>', opts);
-- vim.keymap.set('i', '<C-p>', function()
--   -- return '<C-p>'
--   return vim.fn.pumvisible() == 1 and '<C-p>' or '<Up>'
-- end, { expr = true, replace_keycodes = true, desc = 'Prev item or Up' })

-- keymap('i', '<C-n>', '<Down>', opts);
-- vim.keymap.set('i', '<C-n>', function()
--   -- return '<C-n>'
--   return vim.fn.pumvisible() == 1 and '<C-n>' or '<Down>'
-- end, { expr = true, replace_keycodes = true, desc = 'Next item or Down' })

keymap('i', '<C-f>', '<Right>', opts);
-- vimのデフォルトの <C-d> はインデントを減らす
keymap('i', '<C-b>', '<Left>', opts);

-- vimのデフォルトの <C-a> は前回の挿入で入力した文字列を入力する
keymap('i', '<C-a>', '<Home>', opts);
-- vimのデフォルトの <C-e> は下の行の文字を入力
keymap('i', '<C-e>', '<End>', opts);
-- vimのデフォルトの <C-k> は特殊文字入力
keymap('i', '<C-k>', '<C-o>D', opts);

-- ウィンドウ切り替え
-- keymap('n', '<C-h>', '<C-w>h', opts);
-- keymap('n', '<C-k>', '<C-w>k', opts);
-- keymap('n', '<C-l>', '<C-w>l', opts);

-- ターミナル表示
-- keymap('n', '<Space>;', ':split<CR>:term<CR><C-\\><C-n>:resize 15<CR>i', opts);
-- keymap('n', '<C-;>', ':split<CR>:term<CR><C-\\><C-n>:resize 15<CR>i', opts);

-- keymap('n', 'gt', ':vs<CR><C-w>l<CR>:term<CR>', opts);

-- ターミナルからスムーズにウィンドウ切り替えできるように
keymap('t', '<C-w>', '<C-\\><C-n><C-w>', opts);

-- ターミナル終了
-- keymap('t', '<C-;>', '<C-\\>exit<CR>', opts);

-- ビジュアルモード用のキーマップ (例: <leader>cc)
-- vim.keymap.set('v', '<leader>cc', ':Camel<CR>', { silent = true })

-- coc のフォーマットを使用する
-- keymap('n', '=', '<Plug>(coc-format-selected)', opts);
-- keymap('n', '==', 'gg<Plug>(coc-format-selected)G<C-o>zz', opts);

-- keymap('n', '<C-/', ':CocCommand explorer<CR>', opts)
-- keymap('n', 'gd', '<Plug>(coc-definition)', opts)
-- keymap('n', 'gy', '<Plug>(coc-type-definition)', opts)
-- keymap('n', 'gi', '<Plug>(coc-implementation)', opts)
-- keymap('n', 'gr', '<Plug>(coc-references)', opts)

-- keymap('n', '<C-.>', '<Plug>(coc-fix-current)', opts)
-- keymap('n', '<D-.>', '<Plug>(coc-fix-current)', opts)

-- keymap('n', '<F2>', '<Plug>(coc-rename)', opts)
-- keymap('n', '<F8>', '<Plug>(coc-diagnostic-next)', opts);
-- keymap('n', '<F11>', 'yy:e! <C-r>0<CR>', opts);
-- keymap('n', '<F12>', '<Plug>(coc-definition)', opts)

-- keymap("n", "]e", "<Plug>(coc-diagnostic-next)", opts)
-- keymap("n", "[e", "<Plug>(coc-diagnostic-prev)", opts)

-- keymap("n", "<Space>[", "<Plug>(coc-diagnostic-prev)", opts)
-- keymap("n", "<Space>]", "<Plug>(coc-diagnostic-next)", opts)

-- keymap("n", "<C-p>", "<Plug>(coc-diagnostic-prev)", opts)
-- keymap("n", "<C-n>", "<Plug>(coc-diagnostic-next)", opts)

-- keymap('n', '<C-S-D>', ':CocDiagnostics<CR>', opts);
-- keymap('n', '<C-e>', ':CocCommand explorer<CR>', opts)

-- keymap('n', '<Space>.', '<Plug>(coc-fix-current)', opts)

-- エクスプローラー
-- keymap('n', '<Space>e', ':CocCommand explorer<CR>', opts)

-- エラー一覧
-- keymap('n', '<Space>d', ':CocDiagnostics<CR>', opts);
-- keymap('n', 'ge', ':CocDiagnostics<CR>', opts);

-- keymap('n', '<Space>f', ':CocList grep<CR>', opts)

-- keymap('n', '<Space>w', ':wa<CR>', opts);
-- keymap('n', '<Space>q', ':q<CR>', opts);
-- keymap('n', '<Space>wq', ':wa<CR>:qa<CR>', opts);

-- telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', builtin.find_files)
vim.keymap.set('n', '<leader>g', builtin.live_grep)
vim.keymap.set('n', '<leader>b', builtin.buffers)

-- vim.keymap.set('n', '<C-p>', builtin.find_files)
-- vim.keymap.set('n', '<C-n>', builtin.buffers)

-- LSP
-- vim.keymap.set('n', '<leader>lf', function()
--   vim.lsp.buf.format({ async = true })
-- end)
-- vim.keymap.set('n', '<leader>lr', builtin.lsp_references)

-- fzf.vim
-- keymap('n', '<Space>f', ':Files<CR>', opts)
-- keymap('n', '<Space>r', ':Rg<CR>', opts)
-- keymap('n', '<Space>b', ':Buffer<CR>', opts)

-- keymap('n', '<Space>ff', ':Files<CR>', opts)
-- keymap('n', '<Space>fb', ':Buffer<CR>', opts)
-- keymap('n', '<Space>fl', ':Lines<CR>', opts)
-- keymap('n', '<Space>fr', ':Rg<CR>', opts)
-- -- keymap('n', '<Space>fg', ':Rg<CR>', opts)
-- keymap('n', '<Space>fj', ':Jumps<CR>', opts)
-- keymap('n', '<Space>fw', ':Windows<CR>', opts)
-- keymap('n', '<Space>fh', ':History<CR>', opts)
-- keymap('n', '<Space>fm', ':Marks<CR>', opts)
-- keymap('n', '<Space>fc', ':Commands<CR>', opts)
--
-- keymap('n', '<Space>bf', ':Buffer<CR>', opts)
-- keymap('n', '<Space>bl', ':BLines<CR>', opts)
-- keymap('n', '<Space>bt', ':BTags<CR>', opts)
-- keymap('n', '<Space>bm', ':BMarks<CR>', opts)
-- keymap('n', '<Space>bc', ':BCommands<CR>', opts)
--
-- keymap('n', '<Space>gf', ':GFiles<CR>', opts)
-- keymap('n', '<Space>fg', ':GFiles<CR>', opts)

-- 設定ファイル
-- keymap('n', '<Space>?', ':tabnew ~/.config/nvim/init.lua<CR>', opts);
-- keymap('n', '<Space>r', ':so ~/.config/nvim/init.lua<CR>', opts);

-- コパイロット
-- keymap('i', '<C-j>', 'copilot#Accept(\"<CR>\")', {expr = true, silent = true, script = true})

-- ノーマルモードで gl を叩くと GitLog を実行
--vim.keymap.set('n', 'gl', ':GitLog<CR>', { silent = true })

-- Lua評価＆次行出力関数
local function eval_lua_and_append()
  local mode = vim.api.nvim_get_mode().mode
  local lines

  if mode:match("[vV]") then
    -- ビジュアルモード: 選択範囲を取得
    -- 一度ノーマルモードに戻して選択範囲を確定させる
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "x", true)
    local start_line = vim.api.nvim_buf_get_mark(0, "<")[1]
    local end_line = vim.api.nvim_buf_get_mark(0, ">")[1]
    lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  else
    -- ノーマルモード: カレント行を取得
    lines = {vim.api.nvim_get_current_line()}
  end

  -- コードを結合して実行準備
  local code = table.concat(lines, "\n")

  -- Luaとして評価（先頭に return を付けて試行し、失敗したらそのまま実行）
  local func, err = load("return " .. code)
  if not func then
    func, err = load(code)
  end

  if func then
    local ok, result = pcall(func)
    if ok then
      -- 結果を文字列に変換して次の行に挿入
      _G.res = result
      local output = vim.inspect(result)
      local last_line = mode:match("[vV]") and vim.api.nvim_buf_get_mark(0, ">")[1] or vim.api.nvim_win_get_cursor(0)[1]
      vim.api.nvim_buf_set_lines(0, last_line, last_line, false, { "-- => " .. output })
    else
      print("Error: " .. result)
    end
  else
    print("Error: " .. err)
  end
end

P = vim.inspect
sin = math.sin
cos = math.cos
pi = math.pi

-- キーマッピング
vim.keymap.set({'n', 'v'}, '<leader>j', eval_lua_and_append, { desc = "Evaluate Lua and append result" })

-- [数字]<Leader>k で、任意の行数上から持ってくる
vim.keymap.set('n', '<Leader>k', function()
  local count = vim.v.count == 0 and 1 or vim.v.count
  vim.cmd('.-' .. count .. 't.')
end, { silent = true, desc = "Take line from [count] above" })

vim.keymap.set('n', '<Leader>j', function()
  local count = vim.v.count == 0 and 1 or vim.v.count
  vim.cmd('.+' .. count .. 't.')
end, { silent = true, desc = "Take line from [count] below" })

-- Quickfix ウィンドウをトグル（開いていれば閉じ、エラーがあれば開く）
-- <leader>q (Space + q) で実行
vim.keymap.set('n', '<leader>q', ':cw<CR>', { silent = true, desc = 'Toggle Quickfix' })
vim.keymap.set('n', '[q', ':cprevious<CR>', { silent = true, desc = 'Previous Quickfix Item' })
vim.keymap.set('n', ']q', ':cnext<CR>', { silent = true, desc = 'Next Quickfix Item' })

vim.keymap.set('n', '<C-k>', ':cprevious<CR>zz', { silent = true, desc = 'Previous Quickfix Item' })
vim.keymap.set('n', '<C-j>', ':cnext<CR>zz', { silent = true, desc = 'Next Quickfix Item' })
