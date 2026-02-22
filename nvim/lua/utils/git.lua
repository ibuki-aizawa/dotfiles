local vim = vim;
local M = {}

-- git blame 表示関数 色付き版
function M.git_blame_current_buf()
  local path = vim.fn.expand('%:p')
  local current_line = vim.fn.line('.')

  vim.cmd('enew')
  vim.cmd('setlocal buftype=nofile bufhidden=wipe noswapfile')

  -- git blame を読み込み
  vim.cmd('r !git blame ' .. vim.fn.shellescape(path))
  vim.cmd('1delete')

  -- ★ ここから色付け（Syntaxハイライト）の設定 ★
  -- 1. ハッシュ（先頭の8文字くらい）を特定の色に
  vim.cmd('syntax match BlameHash /^\\^\\?\\x\\+/')
  vim.cmd('highlight default link BlameHash Statement') -- 黄色/オレンジ系

  -- 2. 作者名（カッコの中の最初の部分）を特定の色に
  vim.cmd('syntax match BlameUser /([^)]\\+)/')
  vim.cmd('highlight default link BlameUser Type') -- 緑/水色系

  -- 3. 日付（202x-xx-xx 形式）を特定の色に
  vim.cmd('syntax match BlameDate /\\d\\{4}-\\d\\{2}-\\d\\{2}/')
  vim.cmd('highlight default link BlameDate Comment') -- グレー/青系
  -- ★ ここまで ★

  vim.api.nvim_win_set_cursor(0, {current_line, 0})
  vim.cmd('normal! zz')
  vim.keymap.set('n', 'q', ':bd<CR>', { buffer = true, silent = true })
end

-- Git Diff を表示する共通コア関数
function M.show_git_diff(scope)
  local cmd = 'git diff'
  if scope == 'current' then
    cmd = cmd .. ' ' .. vim.fn.shellescape(vim.fn.expand('%:p'))
  end

  vim.cmd('enew')
  vim.cmd('setlocal buftype=nofile bufhidden=wipe noswapfile filetype=diff')

  -- 外部コマンド実行（エラーハンドリング込）
  local output = vim.fn.system(cmd)
  if output == "" then
    print("No changes found.")
    vim.cmd('bd') -- 差分がなければ閉じる
    return
  end

  -- バッファに内容をセット
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(output, '\n'))

  -- 仕上げ
  vim.keymap.set('n', 'q', ':bd<CR>', { buffer = true, silent = true })
  vim.cmd('normal! gg')
end

-- Git Log: 現在のウィンドウで表示
function M.git_log_current_file()
    local file_path = vim.fn.expand('%:p')
    if file_path == "" then return end

    -- 分割せずに今のウィンドウで新しいバッファを開く
    vim.cmd('enew')
    local log_buf = vim.api.nvim_get_current_buf()
    vim.cmd('setlocal buftype=nofile bufhidden=hide noswapfile filetype=git')

    local log_cmd = "git log --pretty=format:'%h %ad %s' --date=short --follow -- " .. vim.fn.shellescape(file_path)
    local output = vim.fn.systemlist(log_cmd)
    vim.api.nvim_buf_set_lines(log_buf, 0, -1, false, output)

    -- Enterで詳細表示（これも分割しない）
    vim.keymap.set('n', '<CR>', function()
        local hash = vim.fn.expand('<cword>')
        if hash ~= "" then
            vim.cmd('GitShow ' .. hash)
        end
    end, { buffer = log_buf, silent = true })

    vim.keymap.set('n', 'q', ':bd<CR>', { buffer = log_buf, silent = true })
    vim.cmd('normal! gg')
end

-- Git Show: 指定したハッシュの詳細を今のウィンドウで表示
function M.git_show_commit(opts)
    local hash = opts.args
    if hash == "" then
        hash = vim.fn.expand('<cword>')
    end

    if hash == "" then
        print("Commit ID is required")
        return
    end

    -- 今のウィンドウで切り替え
    vim.cmd('enew')
    local show_buf = vim.api.nvim_get_current_buf()
    vim.cmd('setlocal buftype=nofile bufhidden=wipe noswapfile filetype=diff')

    local show_output = vim.fn.systemlist("git show " .. hash)
    if #show_output == 0 then
        print("Invalid Commit ID: " .. hash)
        vim.cmd('bd')
        return
    end

    vim.api.nvim_buf_set_lines(show_buf, 0, -1, false, show_output)

    -- 詳細画面から q で戻ると Log 画面（一つ前のバッファ）に戻る
    vim.keymap.set('n', 'q', ':bd<CR>', { buffer = show_buf, silent = true })
    vim.cmd('normal! gg')
end

-- git status を表示する関数
function M.git_status_project()
  vim.cmd('enew')

  -- bufhidden=hide に変更（前回の気づきを反映！）
  vim.cmd('setlocal buftype=nofile bufhidden=hide noswapfile filetype=gitcommit')

  -- git status を実行
  vim.cmd('r !git status')
  vim.cmd('1delete')

  -- ★ 1. ファイル名に色をつける (Syntaxハイライト)
  -- modified: などの後のファイル名を「Directory(青系)」や「String(緑系)」で目立たせる
  vim.cmd([[
    syntax match GitStatusModified /modified: \+.\+/
    syntax match GitStatusNew /new file: \+.\+/
    syntax match GitStatusFile /.\+$/ containedin=GitStatusModified,GitStatusNew contained

    highlight default link GitStatusModified Comment
    highlight default link GitStatusFile Directory
    highlight default link GitStatusNew Special
  ]])

  -- ★ 2. 初期カーソル位置を最初の modified ファイルへ移動
  -- "/modified:" で検索して、その2単語先（ファイル名）にジャンプ
  local success = pcall(function()
    vim.cmd([[ /modified:/ ]])
    vim.cmd([[ normal! f:3l ]]) -- "modified:" の次の単語(ファイル名)へ移動
  end)

  -- ハイライトを消す
  vim.cmd('nohlsearch')

  -- modified がなかった場合は先頭へ
  if not success then
    vim.cmd('normal! gg')
  end

  vim.keymap.set('n', 'q', ':bd<CR>', { buffer = true, silent = true })
end

return M
