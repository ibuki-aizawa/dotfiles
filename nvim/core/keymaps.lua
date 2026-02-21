local vim = vim;

-- keymap
local opts = {
	noremap = true,
	silent = true,
}

local keymap = vim.api.nvim_set_keymap

-- command + s で保存(macOS)
keymap('n', '<D-s>', ':wa<CR>', opts);
keymap('n', '<D-w>', ':qa<CR>', opts);

-- keymap('n', 'n', 'nzz', opts);
-- keymap('n', 'N', 'Nzz', opts);
-- keymap('n', '*', '*zz', opts);

-- コマンドラインで %% と打つと、今のファイルがあるディレクトリに置換する
vim.keymap.set('c', '%%', "getcmdtype() == ':' ? expand('%:h') . '/' : '%%'", { expr = true })

-- %: : ディレクトリ + 今のファイル名
-- これで :e %: と打つと "path/to/current_file.lua" が展開される
vim.keymap.set('c', '%:', "getcmdtype() == ':' ? expand('%:p') : '%:'", { expr = true })

-- %. : 拡張子抜きのフルパス (例: main.lua -> main)
-- 「main_spec.lua」などを隣に作りたい時に便利！
vim.keymap.set('c', '%.', "getcmdtype() == ':' ? expand('%:p:r') : '%.'", { expr = true })

-- %t : ファイル名だけ (例: path/to/login.ts -> login.ts)
vim.keymap.set('c', '%t', "getcmdtype() == ':' ? expand('%:t') : '%t'", { expr = true })

-- %h : ファイル名だけ（拡張子なし） (例: login.ts -> login)
vim.keymap.set('c', '%h', "getcmdtype() == ':' ? expand('%:t:r') : '%h'", { expr = true })

-- keymap('n', 'gj', '15jzz', opts);
-- keymap('n', 'gk', '15kzz', opts);
-- keymap('n', 'gl', '15lzz', opts);
-- keymap('n', 'gh', '15hzz', opts);

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
vim.keymap.set('v', '<leader>cc', ':Camel<CR>', { silent = true })

-- coc のフォーマットを使用する
-- keymap('n', '=', '<Plug>(coc-format-selected)', opts);
-- keymap('n', '==', 'gg<Plug>(coc-format-selected)G<C-o>zz', opts);

-- keymap('n', '<C-/', ':CocCommand explorer<CR>', opts)
keymap('n', 'gd', '<Plug>(coc-definition)', opts)
keymap('n', 'gy', '<Plug>(coc-type-definition)', opts)
keymap('n', 'gi', '<Plug>(coc-implementation)', opts)
keymap('n', 'gr', '<Plug>(coc-references)', opts)

keymap('n', '<C-.>', '<Plug>(coc-fix-current)', opts)
keymap('n', '<D-.>', '<Plug>(coc-fix-current)', opts)

keymap('n', '<F2>', '<Plug>(coc-rename)', opts)
keymap('n', '<F8>', '<Plug>(coc-diagnostic-next)zz', opts);
-- keymap('n', '<F11>', 'yy:e! <C-r>0<CR>', opts);
keymap('n', '<F12>', '<Plug>(coc-definition)', opts)

keymap("n", "[e", "<Plug>(coc-diagnostic-prev)zz", opts)
keymap("n", "]e", "<Plug>(coc-diagnostic-next)zz", opts)

-- keymap("n", "<Space>[", "<Plug>(coc-diagnostic-prev)zz", opts)
-- keymap("n", "<Space>]", "<Plug>(coc-diagnostic-next)zz", opts)

keymap("n", "<C-p>", "<Plug>(coc-diagnostic-prev)zz", opts)
keymap("n", "<C-n>", "<Plug>(coc-diagnostic-next)zz", opts)

-- keymap('n', '<C-S-D>', ':CocDiagnostics<CR>', opts);
-- keymap('n', '<C-e>', ':CocCommand explorer<CR>', opts)

keymap('n', '<Space>.', '<Plug>(coc-fix-current)', opts)

-- エクスプローラー
keymap('n', '<Space>e', ':CocCommand explorer<CR>', opts)

-- エラー一覧
keymap('n', '<Space>d', ':CocDiagnostics<CR>', opts);
keymap('n', 'ge', ':CocDiagnostics<CR>', opts);

-- keymap('n', '<Space>f', ':CocList grep<CR>', opts)

keymap('n', '<Space>w', ':wa<CR>', opts);
keymap('n', '<Space>q', ':q<CR>', opts);
keymap('n', '<Space>wq', ':wa<CR>:qa<CR>', opts);

-- fzf.vim

-- keymap('n', '<Space><Space>', ':Files<CR>', opts)
keymap('n', '<Space>ff', ':Files<CR>', opts)
keymap('n', '<Space>fb', ':Buffer<CR>', opts)
keymap('n', '<Space>fl', ':Lines<CR>', opts)
keymap('n', '<Space>fr', ':Rg<CR>', opts)
-- keymap('n', '<Space>fg', ':Rg<CR>', opts)
keymap('n', '<Space>fj', ':Jumps<CR>', opts)
keymap('n', '<Space>fw', ':Windows<CR>', opts)
keymap('n', '<Space>fh', ':History<CR>', opts)
keymap('n', '<Space>fm', ':Marks<CR>', opts)
keymap('n', '<Space>fc', ':Commands<CR>', opts)

keymap('n', '<Space>bf', ':Buffer<CR>', opts)
keymap('n', '<Space>bl', ':BLines<CR>', opts)
keymap('n', '<Space>bt', ':BTags<CR>', opts)
keymap('n', '<Space>bm', ':BMarks<CR>', opts)
keymap('n', '<Space>bc', ':BCommands<CR>', opts)

keymap('n', '<Space>gf', ':GFiles<CR>', opts)
keymap('n', '<Space>fg', ':GFiles<CR>', opts)

-- 設定ファイル
-- keymap('n', '<Space>?', ':tabnew ~/.config/nvim/init.lua<CR>', opts);
-- keymap('n', '<Space>r', ':so ~/.config/nvim/init.lua<CR>', opts);

-- コパイロット
keymap('i', '<C-j>', 'copilot#Accept(\"<CR>\")', {expr = true, silent = true, script = true})
