" Vim configuration file

syntax on " シンタックスハイライトを有効化

set mouse=a "マウス使用

set fileformats=unix,mac,dos " ファイルフォーマットを指定
set encoding=utf-8 "文字コードをUTF-8に

set showmode "ステータスラインにモードを表示
set title "タイトルを表示

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

"Escの2回押しでハイライト消去
nmap <Esc><Esc> :nohlsearch<CR><ESC>

"ビジュアルモード時ctrl+cでシステムクリップボードにコピー
vmap <C-C> "+y
