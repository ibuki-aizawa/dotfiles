# bashrc
ln -sf $(pwd)/.bashrc ~/.bashrc

# zshrc
ln -sf $(pwd)/.zshrc ~/.zshrc

# .inputrc
ln -sf $(pwd)/.inputrc ~/.inputrc

# vim
ln -sf $(pwd)/.vimrc ~/.vimrc

# nvim
mkdir -p ~/.config/
ln -sf $(pwd)/nvim ~/.config/

# emacs
ln -s $(pwd)/.emacs.d ~/.emacs.d

# ripgrep
ln -s $(pwd)/.ripgreprc ~/.ripgreprc

# npmrc
ln -s $(pwd)/.npmrc ~/.npmrc
