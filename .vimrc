"~/.vimrc

syntax on "シンタックスを有効化
set title "タイトルを表示
set number "行番号を表示
set nowrap "折り返しなし
set cursorline "行強調
"タブ文字、行末空白を表示
exec "set listchars=tab:\uBB.,trail:_"
set list "listcharsを有効化
"set visualbell "ビープ音を可視化
set belloff=all "ビープ音を無効化

set smartindent "自動インデント
set shiftwidth=4 "行頭のタブ長
set tabstop=4 "行頭以外のタブ長
set formatoptions=r "改行時コメント継続
set helplang=ja,en "ヘルプ言語
set mouse=a "マウス使用

set noswapfile "スワップファイルを作らない
set undodir=~/.vim/undo "アンドゥファイル用のディレクトリ
set undofile "アンドゥの永続化

set ignorecase "検索時大文字小文字を区別しない
set wrapscan "検索時一周する
set hlsearch "検索結果を強調
"Escの2回押しでハイライト消去
nnoremap <Esc><Esc> :nohlsearch<CR><ESC>
"ビジュアルモード時ctrl+cでシステムクリップボードにコピー
vnoremap <C-C> "+y

set completeopt=menuone,preview "候補が一つでもポップアップ、付加的な情報をプレビュー

"https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/plugged')
Plug 'mattn/emmet-vim' "emmet
Plug 'thinca/vim-quickrun' "quickrun
Plug 'lambdalisue/fern.vim' "fern
Plug 'lambdalisue/fern-git-status.vim' "fern-git
Plug 'cohama/lexima.vim' "lexima
Plug 'joshdick/onedark.vim' "onedark
call plug#end()

colorscheme onedark

let g:quickrun_config = get(g:, 'quickrun_config', {})
let g:quickrun_config._ = {
    \ 'outputter/buffer/opener': 'new',
    \ 'outputter/buffer/close_on_empty': 1,
    \ }
set splitbelow
nnoremap <leader>r :QuickRun<CR>
nnoremap <F5> :QuickRun<CR>
nnoremap <leader>m :make<CR>

let g:fern#default_hidden=1
nnoremap <C-e> :Fern . -reveal=% -drawer -toggle -width=40<CR>
