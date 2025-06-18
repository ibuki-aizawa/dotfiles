# dotfiles

## zsh

```zsh
mkdir -p ~/repo

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/repo/powerlevel10k
echo 'source ~/repo/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc

ln -s "$./zsh/.zshrc" "$HOME/.zshrc"

```

## git

```bash
ln -s "./git/.gitconfig" "$HOME/.gitconfig"
```

## vim

```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

## neovim

```bash

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
