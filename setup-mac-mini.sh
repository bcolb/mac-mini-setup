#!/bin/bash
# Mac Mini M4 Setup Script - AI & Development Environment
# Author: Brice Colbert
# Run: bash setup-mac-mini.sh

set -e

echo "Mac Mini M4 Setup - AI & Development Environment"
echo "=================================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Ask for sudo upfront
sudo -v

# Keep sudo alive
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo -e "${GREEN}1. Installing Xcode Command Line Tools${NC}"
xcode-select --install 2>/dev/null || echo "Already installed"

echo ""
echo -e "${GREEN}2. Installing Homebrew${NC}"
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Homebrew already installed"
fi

echo ""
echo -e "${GREEN}3. Installing Essential Tools${NC}"
brew install \
    git \
    wget \
    curl \
    jq \
    ripgrep \
    fd \
    bat \
    htop \
    btop \
    tree \
    tldr

echo ""
echo -e "${GREEN}4. Installing GUI Applications${NC}"
brew install --cask \
    iterm2 \
    visual-studio-code \
    docker \
    rectangle \
    stats \
    claude

echo ""
echo -e "${GREEN}5. Installing Oh My Zsh${NC}"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    sed -i '' 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/' ~/.zshrc
else
    echo "Oh My Zsh already installed"
fi

echo ""
echo -e "${GREEN}6. Installing Python Environment (pyenv)${NC}"
brew install pyenv pyenv-virtualenv

cat >> ~/.zprofile << 'PYENV'

# Pyenv configuration
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
PYENV

source ~/.zprofile

echo ""
echo -e "${GREEN}7. Installing Python Versions${NC}"
pyenv install 3.13.1
pyenv install 3.12.8
pyenv global 3.13.1

echo ""
echo -e "${GREEN}8. Installing AI Tools${NC}"

brew install ollama
brew services start ollama

read -p "Install LM Studio? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    brew install --cask lm-studio
fi

echo ""
echo -e "${GREEN}9. Installing Database Tools${NC}"
brew install --cask tableplus nosql-workbench

echo ""
echo -e "${GREEN}10. Installing Syncthing${NC}"
brew install syncthing
brew services start syncthing

echo ""
echo -e "${GREEN}11. Configuring System Settings${NC}"

echo "Disabling system sleep..."
sudo pmset -a disablesleep 1

echo "Enabling SSH..."
sudo systemsetup -setremotelogin on

defaults write com.apple.finder AppleShowAllFiles -bool true
killall Finder

defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

echo ""
echo -e "${GREEN}12. Configuring Git${NC}"
read -p "Enter your name for Git: " git_name
read -p "Enter your email for Git: " git_email

git config --global user.name "$git_name"
git config --global user.email "$git_email"
git config --global init.defaultBranch main
git config --global core.editor "code --wait"

git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

echo ""
echo -e "${GREEN}13. Generating SSH Keys${NC}"
if [ ! -f ~/.ssh/id_ed25519 ]; then
    ssh-keygen -t ed25519 -C "$git_email" -f ~/.ssh/id_ed25519 -N ""
    eval "$(ssh-agent -s)"
    ssh-add --apple-use-keychain ~/.ssh/id_ed25519
    
    echo ""
    echo -e "${YELLOW}Add this SSH key to GitHub:${NC}"
    cat ~/.ssh/id_ed25519.pub
    echo ""
    echo "Press Enter when you've added the key to GitHub..."
    read
else
    echo "SSH key already exists"
fi

echo ""
echo -e "${GREEN}14. Creating Directory Structure${NC}"
mkdir -p ~/projects
mkdir -p ~/services
mkdir -p ~/.config

echo ""
echo -e "${GREEN}Basic Setup Complete${NC}"
echo ""
echo "Next steps:"
echo "1. Create AI environment: bash setup-ai-env.sh"
echo "2. Download Ollama models: bash setup-ollama-models.sh"
echo "3. Configure Syncthing to connect with MacBook Air"
echo "4. Install heartbeat client"
echo ""
