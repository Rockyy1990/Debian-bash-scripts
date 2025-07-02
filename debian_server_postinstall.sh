#!/usr/bin/env bash

echo ""
echo "Debian Server Postinstall Script"
echo ""
read -p "Press any key to continue.."
clear

sudo apt dist-upgrade -y

sudo apt install -y synaptic flatpak 
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

sudo flatpak install -y flathub com.github.tchx84.Flatseal
sudo flatpak install -y org.freedesktop.Platform.ffmpeg-full 
sudo flatpak install -y flathub fr.handbrake.ghb
sudo flatpak install -y flathub io.github.celluloid_player.Celluloid
sudo flatpak install -y flathub org.soundconverter.SoundConverter
sudo flatpak install flathub org.mozilla.firefox




# Install webmin interface
curl -o webmin-setup-repo.sh https://raw.githubusercontent.com/webmin/webmin/master/webmin-setup-repo.sh
sudo sh webmin-setup-repo.sh
sudo apt-get install webmin samba --install-recommends


# Install xanmod kernel
wget -qO - https://dl.xanmod.org/archive.key | sudo gpg --dearmor -vo /etc/apt/keyrings/xanmod-archive-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/xanmod-archive-keyring.gpg] http://deb.xanmod.org releases main' | sudo tee /etc/apt/sources.list.d/xanmod-release.list
sudo apt update
sudo apt install --no-install-recommends clang lld llvm libelf-dev linux-xanmod-x64v3


# makemkv
sudo su
wget https://apt.benthetechguy.net/benthetechguy-archive-keyring.gpg -O /usr/share/keyrings/benthetechguy-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/benthetechguy-archive-keyring.gpg] https://apt.benthetechguy.net/debian bookworm non-free" > /etc/apt/sources.list.d/benthetechguy.list
apt update
sudo apt install makemkv libmakemkv1 libmmbd0
