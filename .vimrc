
"### Plug ###
" https://github.com/junegunn/vim-plug
" 書き加えたら、:PlugInstall を実行する
"
" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')
" Make sure you use single quotes
" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'
" Any valid git URL is allowed
Plug 'https://github.com/junegunn/vim-github-dashboard.git'
" Multiple Plug commands can be written in a single line using | separators
"Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'tpope/vim-fireplace', { 'for': 'clojure' }
" Using a non-master branch
Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }
" Using a tagged release; wildcard allowed (requires git 1.9.2 or above)
Plug 'fatih/vim-go', { 'tag': '*' }
" Plugin options
Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }
" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" Unmanaged plugin (manually installed and updated)
Plug '~/my-prototype-plugin'
" my
Plug 'vim-jp/vimdoc-ja'
Plug 'sonjapeterson/1989.vim'
Plug 'dense-analysis/ale'
Plug 'pgavlin/pulumi.vim'
" Initialize plugin system
call plug#end()

"### カラースキーム ###
"colorscheme pulumi
colorscheme 1989

syntax on "シンタックスを有効化
set title "タイトルを表示
set number "行番号を表示
set nowrap "折り返しなし
set cursorline "行強調
"タブ文字、行末空白を表示
exec "set listchars=tab:\uBB.,trail:_"
set list "listcharsを有効化
set smartindent "自動インデント
"set visualbell "ビープ音を可視化
set belloff=all "ビープ音を無効化
set shiftwidth=4 "行頭のタブ長
set tabstop=4 "行頭以外のタブ長
set formatoptions=r "改行時コメント継続
set helplang=ja,en "ヘルプ言語
set mouse=a

set noswapfile "スワップファイルを作らない
set undodir=~/.vim/undo "アンドゥファイル用のディレクトリ
set undofile "アンドゥの永続化

set ignorecase "検索時大文字小文字を区別しない
set wrapscan "検索時一周する
set hlsearch "検索結果を強調
"検索結果強調を切替
nnoremap <silent><Esc><Esc> :<C-u>set nohlsearch!<CR>
"ビジュアルモード時ctrl+cでシステムクリップボードにコピー
vmap <C-C> "+y

set completeopt=menuone,preview "候補が一つでもポップアップ、負荷的な情報をプレビュー
"補完候補を常に表示
for k in split("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_",'\zs')
    exec "imap " . k . " " . k . "<C-N><C-P>"
endfor
