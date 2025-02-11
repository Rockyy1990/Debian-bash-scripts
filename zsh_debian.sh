#!/usr/bin/env bash

# Last Edit: 10.02.2025

echo ""
echo "----------------------------------------------"
echo "              ..Z Shell install..             "
echo "              debian based distros            "
echo "----------------------------------------------"
sleep 3
read -p "Press any key to continue.."

sudo apt install -y zsh

chsh -s $(which zsh)

sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

echo "plugins=(git zsh-autosuggestions)" | sudo tee -a ~/.zshrc

source ~/.zshrc

read -p "Install and config now complete. Press any key to reboot."
sudo reboot