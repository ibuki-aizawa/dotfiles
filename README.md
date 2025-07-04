# dotfiles

## setup

```bash
git clone https://github.com/ibuki-aizawa/dotfiles.git
cd dotfiles
```

## zsh

```zsh
echo "
[[ ! -f $(pwd)/zshrc ]] || source $(pwd)/zshrc
" >> ~/.zshrc
```

- https://github.com/romkatv/powerlevel10k

## vim

```bash
echo "

source $(pwd)/vimrc

" >> ~/.vimrc
```

## nvim

```bash
echo "

vim.cmd('source $(pwd)/vimrc');
dofile('$(pwd)/base.lua');

" >> ~/.config/nvim/init.lua
```

- https://github.com/junegunn/vim-plug
- https://github.com/github/copilot.vim
- https://github.com/neoclide/coc.nvim
- https://github.com/lambdalisue/vim-fern
- https://github.com/mattn/emmet-vim

## git

```bash
git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global core.autocrlf input
git config --global core.quotepath false
git config --global color.ui auto
git config --global core.editor "nvim"
git config --global core.pager "less -q"
```

## PoserShell

```ps1
Set-ExecutionPolicy RemoteSigned

echo '$script = "$Home\.profile.ps1"

if (Test-Path $script) {
    . $script
}
' > $profile
```
