# dotfiles

## setup

```bash
git clone https://github.com/ibuki-aizawa/dotfiles.git
cd dotfiles
```

## zsh

```zsh
echo "
[[ ! -f $(pwd)/shell/zshrc ]] || source $(pwd)/shell/zshrc
" >> ~/.zshrc
```

- https://github.com/romkatv/powerlevel10k

## vim

```bash
echo "

source $(pwd)/vim/vimrc

" >> ~/.vimrc
```

## nvim

```bash
echo "

vim.cmd('source $(pwd)/vim/vimrc');
vim.cmd('source $(pwd)/vim/coc.vim');
dofile('$(pwd)/vim/nvim.lua');

" >> ~/.config/nvim/init.lua
```

- https://github.com/junegunn/vim-plug
- https://github.com/neoclide/coc.nvim
- https://github.com/github/copilot.vim

## emacs

```bash
echo "

 (add-to-list 'load-path "$(pwd)/dotfiles/emacs")
 (load "emacs.el")

" >> ~/.emacs.d/emacs.el

```

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

echo '$script = "$(pwd)/powershell/profile.ps1"

if (Test-Path $script) {
    . $script
}
' > $profile
```
