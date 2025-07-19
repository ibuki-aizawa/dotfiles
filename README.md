# dotfiles

## bash

```bash
ln -s $(pwd)/.bashrc ~/.bashrc
```

## zsh

```zsh
ln -s $(pwd)/.zshrc ~/.zshrc
```

- https://github.com/romkatv/powerlevel10k

## vim / neovim

```bash
ln -s $(pwd)/.vimrc ~/.vimrc
mkdir -p ~/.config/nvim
ln -s $(pwd)/nvim ~/.config/nvim
```

- https://github.com/junegunn/vim-plug
- https://github.com/neoclide/coc.nvim
- https://github.com/github/copilot.vim

## emacs

```bash
ln -s $(pwd)/.emacs.d ~/.emacs.d
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

echo '$script = "$(pwd)/profile.ps1"

if (Test-Path $script) {
    . $script
}
' > $profile
```
