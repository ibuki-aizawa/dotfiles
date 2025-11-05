# dotfiles

## setup (macOS)

```bash
./setup-macos.sh
```

## setup (bash, zsh)

```bash
./apt-install.sh

# nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

# node
nvm install --lts
nvm use --lts

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# bashrc
ln -sf $(pwd)/.bashrc ~/.bashrc

# zshrc
ln -sf $(pwd)/.zshrc ~/.zshrc

# .inputrc
ln -sf $(pwd)/.inputrc ~/.inputrc

mkdir -p ~/repo

# Powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/repo/powerlevel10k

# z
git clone https://github.com/rupa/z.git ~/repo/z

# peda
git clone https://github.com/longld/peda.git ~/repo/peda
echo "source ~/repo/peda/peda.py" >> ~/.gdbinit

# vim
ln -sf $(pwd)/.vimrc ~/.vimrc

# nvim
mkdir -p ~/.config/
ln -sf $(pwd)/nvim ~/.config/

# vim.plug for nvim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# emacs
ln -s $(pwd)/.emacs.d ~/.emacs.d

# git
git config --global init.defaultBranch main
git config --global pull.rebase false
git config --global core.autocrlf input
git config --global push.autosetupremote true
git config --global core.quotepath false
git config --global color.ui auto
git config --global core.editor "nvim"
git config --global core.pager "less -q"

sudo update-alternatives --config editor
```

## use zsh

```bash
sudo usermod -s /bin/zsh $(id -un)
```

## links
- https://github.com/romkatv/powerlevel10k
- https://github.com/junegunn/vim-plug
- https://github.com/neoclide/coc.nvim
- https://github.com/github/copilot.vim

## PoserShell

```ps1
Set-ExecutionPolicy RemoteSigned

echo '$script = "$(pwd)/profile.ps1"

if (Test-Path $script) {
    . $script
}
' > $profile
```
