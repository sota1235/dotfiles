#!/bin/sh

brew update
brew upgrade

brew install gist
brew install git
brew install git-extras
brew install peco
brew install tig
brew install highlight
brew install tmux
brew install mysql
brew install mycli
brew install pgcli
brew install yarn
brew install zsh
brew install ffmpeg
brew install htop
brew install jq
brew install wget
brew install coreutils
brew install tree
brew install bat
brew install reattach-to-user-namespace
brew install terminal-notifier
brew install ghq
brew install direnv
brew install trash
brew install awscli
brew install pgcli
brew install gh
brew install imagemagick
brew install deno
brew install yt-dlp
brew install jnv
brew install sheldon

# terraform refs https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

brew install --cask iterm2
brew install --cask docker
brew install --cask google-chrome
brew install --cask google-japanese-ime
brew install --cask appcleaner
brew install --cask spotify
brew install --cask visual-studio-code
brew install --cask jetbrains-toolbox
brew install --cask karabiner-elements
brew install --cask alfred
brew install --cask firefox
brew install --cask vlc
brew install --cask dropbox
brew install --cask gyazo
brew install --cask google-cloud-sdk
brew install --cask clipy
brew install --cask figma
brew install --cask audacity
brew install --cask asana
brew install --cask elgato-stream-deck
brew install --cask vanilla
brew install --cask 1password
brew install --cask rambox
brew install --cask sequel-ace

brew install mas

mas install 409183694   # Keynote
mas install 803453959   # Slack
mas install 539883307   # LINE
mas install 1287239339  # ColorSlurp
mas install 441258766   # Magnet
mas install 497799835   # XCode
mas install 490505997   # Skitch
mas install 405399194   # Kindle
mas install 1429033973  # Runcat
mas install 1291898086  # toggl-track

# auto update
brew tap homebrew/autoupdate
brew autoupdate start
