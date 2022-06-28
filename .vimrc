
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


"## 各種設定 ###
set nu				"行番号
set mouse=a			"マウス使用可能
syntax on			"シンタックス
set cursorline		"カーソルライン表示
set visualbell		"Beep音を可視化(音も消える)
"set belloff=all	"Beep音を鳴らさない
set shiftwidth=4	"行頭でのタプ長
set tabstop=4		"行頭以外でのタブ長
"set smartindent	"カレント行のインデントをキープ、シンプル
"set autoindent		"C言語風の自動インデント
set cindent			"もっとも厳格にC言語特化
set hlsearch		"検索結果をハイライト
set formatoptions=r	"自動コメントアウト
set helplang=ja
"Esc二度押しでハイライト切り替え
nnoremap <silent><Esc><Esc> :<C-u>set nohlsearch!<CR>

"### Ctags 設定 ###
set fileformats=unix,dos,mac
set fileencodings=utf-8,sjis
set tags=.tags;$HOME
function! s:execute_ctags() abort
  " 探すタグファイル名
  let tag_name = '.tags'
  " ディレクトリを遡り、タグファイルを探し、パス取得
  let tags_path = findfile(tag_name, '.;')
  " タグファイルパスが見つからなかった場合
  if tags_path ==# ''
    return
  endif
  " タグファイルのディレクトリパスを取得
  " `:p:h`の部分は、:h filename-modifiersで確認
  let tags_dirpath = fnamemodify(tags_path, ':p:h')
  " 見つかったタグファイルのディレクトリに移動して、ctagsをバックグラウンド実行（エラー出力破棄）
  execute 'silent !cd' tags_dirpath '&& ctags -R -f' tag_name '2> /dev/null &'
endfunction

augroup ctags
  autocmd!
  autocmd BufWritePost * call s:execute_ctags()
augroup END

"### キーバインド系 ###
nmap j gj
nmap k gk
imap <C-:> <Esc>:

"### C/C++ ##########
vmap c/ :s@^@\/\/@g<Enter>
vmap c*	:s@^\(.*\)$@/* \1 */@g<Enter>/コメントアウトしたお( ^ω^ )<Enter>
imap {<Enter> {<Enter>}<Esc><S-o>
imap ?? /*  */<Left><Left><Left>
imap /** /**<Enter>/<Esc><S-o>
imap /:: / <C-h>**<Enter>/<Esc><S-o>@fn<Enter>@brief<Tab><Enter>@param<Tab><Enter>@return<Tab><Esc>3<Up><S-a><Tab><Tab>

"### Temprates #####
autocmd BufNewFile *.c 0r ~/Templates/sample.c
autocmd BufNewFile *.cs 0r ~/Templates/sample.cs
autocmd BufNewFile *.html 0r ~/Templates/sample.html
"autocmd BufNewFile *.cpp 0r ~/Templates/cplusplus.cpp
"autocmd BufNewFile *.cc 0r ~/Templates/cplusplus.cpp
"autocmd BufNewFile *.tex 0r ~/Templates/tex.tex
"autocmd BufNewFile beamer.tex 0r ~/Templates/beamer.tex
"Autocmd BufNewFile Makefile 0r ~/Templates/Makefile

"### 補完候補を常に表示 ###
set completeopt=menuone
for k in split("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_",'\zs')
  exec "imap " . k . " " . k . "<C-N><C-P>"
endfor
imap <expr> <TAB> pumvisible() ? "\<Down>" : "\<Tab>"

"### html ###
" imap <>! <!DOCTYPE html><Enter><html lang="ja"><Enter><head><Enter><meta charset="utf-8" /><Enter><title></title><Enter></head><Enter><body><Enter></body><Enter></html><Esc>4kwf<i
" imap <>html <html></html><Left><Left><Left><Left><Left><Left><Left>
" imap <>body <body></body><Left><Left><Left><Left><Left><Left><Left>
" imap <>head <head></head><Left><Left><Left><Left><Left><Left><Left>
" imap <>p <p></p><Left><Left><Left><Left>
" imap <>a <a href="#"></a><Left><Left><Left><Left><Left><Left>
" vmap c! :s@^\(.*\)@<!-- \1 -->@g<Enter>
" vmap c1 :s@<!-- \(.*\) -->@\1@g<Enter>


"### .vimrc end ###
