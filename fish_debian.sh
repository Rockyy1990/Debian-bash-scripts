#!/usr/bin/env bash

# Last Edit: 10.02.2025

echo ""
echo "----------------------------------------------"
echo "             ..Fish Shell install..           "
echo "              debian based distros            "
echo "----------------------------------------------"
sleep 3
read -p "Press any key to continue.."

sudo apt install -y fish

chsh -s /usr/bin/fish

echo "set -x PATH /usr/local/bin $PATH"| sudo tee -a ~/.config/fish/config.fish

read -p "Install and config now complete. Press any key to reboot."
sudo reboot