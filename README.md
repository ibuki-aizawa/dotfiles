# dotfiles

## .zshrc
https://github.com/romkatv/powerlevel10k

## .vimrc
```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

## profile.ps1
```
Set-ExecutionPolicy RemoteSigned

echo '$script = "$Home\.profile.ps1"

if (Test-Path $script) {
    . $script
}
' > $profile
```


