
# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# dev tools
brew install bat
brew install fzf
brew install neovim
brew install p7zip
brew install ripgrep
brew install peco

# runtime
brew install nvm
nvm install lts
nvm use lts

## java
brew install jenv
echo '
# java config
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
' >> ~/.zsh_profile
brew install openjdk@17
jenv add /opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home
brew install openjdk@22
jenv add /opt/homebrew/opt/openjdk@22/libexec/openjdk.jdk/Contents/Home
jenv global 22

## ruby
brew install rbenv
rbenv init
rbenv install 3.2.2
rbenv global 3.2.2
# sudo gem install cocoapods -v 1.15.2

# database
brew install postgresql@17


