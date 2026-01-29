" Vim configuration file

" vim 備忘
" zz 中央にスクロール
" zt 上にスクロール
" zb 下にスクロール
" <C-y> 上に一行スクロール
" <C-e> 下に一行スクロール
"
" :vimgrep <pattern> <file> でファイル内検索
" :vimgrep <pattern> % で自ファイル内検索
" :vimgrep <pattern> %:h** でカレントディレクトリ以下の全ファイルを検索
"
" vimgrep の結果は :cw[indow] で開く
"
" レジスタ一覧
"  - :reg レジスタ一覧 :reg
"  - :a-z 名前付きレジスタ
"  - :+   システムクリップボード
"  - "_   ブラックホールレジスタ
"  - "0   ヤンクした内容が入る（削除では更新されない）
"  - ""   デフォルトレジスタ
"
"  ex) "ayy - レジスタ a にヤンク
"      "ap  - レジスタ a からペースト
"
" コマンドモードで使える特殊文字
"   % - 開いているファイルのパス
"   %:h - 開いているファイルのディレクトリパス
"   %:t - 開いているファイルのファイル名
"
" コマンドモード
"   - <C-r>% - 開いているファイルのパスを挿入
"   - ノーマルモードを使うには、<C-F> を使う
"   - レジスタを使うには、<C-R>{レジスタ名} を使う
"

syntax on " シンタックスハイライトを有効化

"let mapleader = "\<Space>" "リーダーキーをスペースに設定

set mouse=a "マウス使用
"map <MouseDown> <C-Y>M
"map <S-MouseDown> <C-U>M
"map <MouseUp> <C-E>M
"map <S-MouseUp> <C-D>M

set fileformats=unix,mac,dos " ファイルフォーマットを指定
set encoding=utf-8 "文字コードをUTF-8に

set showmode "ステータスラインにモードを表示
set title "タイトルを表示

" vimgrep の設定
set wildignore+=.git/**,node_modules/**,dist/**,build/**,coverage/**,*.html

" zc で折りたたみ、zo で展開
set foldmethod=indent "インデントで折りたたみ
set foldlevel=99 "折りたたみの初期レベルを99に設定

" 正規表現エンジンを指定
set re=0
set cursorline "現在行を強調
set nu
set relativenumber "相対行番号を表示

set nowrap "折り返しなし
set cursorline "行強調
"set nohlsearch "検索結果のハイライトを無効化

"タブ文字、行末空白を表示
exec "set listchars=tab:\uBB.,trail:_"
set list "listcharsを有効化

"set visualbell "ビープ音を可視化
set belloff=all "ビープ音を無効化

"set autoindent
set smartindent "自動インデント

set expandtab "Tabキーでスペース入力
set tabstop=2 "行頭以外のタブ長
set shiftwidth=2 "行頭のタブ長
set softtabstop=2 "ソフトタブの長さ

" filetype は :echo &filetype で確認できる
autocmd FileType python setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4 "Pythonファイルではタブをスペース4つに設定
autocmd FileType c setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd FileType rust setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4

set formatoptions=r "改行時コメント継続

set helplang=ja,en "ヘルプ言語

"set noswapfile "スワップファイルを作らない
set undofile "アンドゥの永続化
set undodir=~/.vim/undo "アンドゥファイル用のディレクトリ

set ignorecase "検索時大文字小文字を区別しない
set wrapscan "検索時一周する
set hlsearch "検索結果を強調

set completeopt=menuone,preview "候補が一つでもポップアップ、付加的な情報をプレビュー

set splitbelow "スプリット

" mapの設定
"nnoremap j jzz
"nnoremap k kzz
"nnoremap G Gzz
"nnoremap <C-w>l <C-w>lzz
"nnoremap <C-w>h <C-w>hzz
"nnoremap <C-o> <C-o>zz
"nnoremap <C-i> <C-i>zz
"nnoremap <C-u> <C-u>zz
"nnoremap <C-d> <C-d>zz
"nnoremap { {zz
"nnoremap } }zz
"
"vmap j jzz
"vmap k kzz
"vmap G Gzz
"vmap <C-o> <C-o>zz
"vmap <C-i> <C-i>zz
"vmap <C-u> <C-u>zz
"vmap <C-d> <C-d>zz
"vmap { {zz
"vmap } }zz

nnoremap <F3> :vimgrep <C-R>=expand('<cword>')<CR> **<CR>:copen<CR>

"nnoremap <C-e> 5<C-e>M
"nnoremap <C-y> 5<C-y>M

"Escの2回押しでハイライト消去
nnoremap <Esc><Esc> :nohlsearch<CR><ESC>

"ビジュアルモード時ctrl+cでシステムクリップボードにコピー
vmap <C-C> "+y

"ウィンドウの幅を調整
nnoremap <C-w><C-w> :vs<CR>:q<CR>

nnoremap <Space>tn :tabnew<CR><C-o>
nnoremap <Space>tl :tabnext<CR>
nnoremap <Space>th :tabprevious<CR>

" nnoremap <Space>v :vs<CR>
nnoremap <Space>? :e ~/.vimrc<CR>


nnoremap <Right> :tabnext<CR>
nnoremap <Left> :tabprevious<CR>

let g:IMState = 0
autocmd InsertEnter * let &iminsert = g:IMState
autocmd InsertLeave * let g:IMState = &iminsert|set iminsert=0 imsearch=0
