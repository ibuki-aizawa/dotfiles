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

# Powerlevel10k
mkdir -p ~/repo
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/repo/powerlevel10k

# z
git clone https://github.com/rupa/z.git ~/repo/z

# peda
git clone https://github.com/longld/peda.git ~/repo/peda
echo "source ~/repo/peda/peda.py" >> ~/.gdbinit

# vim.plug for nvim
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

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
