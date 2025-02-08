!/usr/bin/env bash

# Last Edit: 08.02.2025

echo ""
echo "----------------------------------------------"
echo "      ..Debian config after install..         "
echo "               Plasma Desktop                 "
echo "----------------------------------------------"
sleep 3
echo ""
echo "      !!!You should read this script first!!!
"


# Remove unneeded packages
sudo apt install -y juk dragonplayer gimp akregator


read -p "If not set: add contrib non-free non-free-firmware to the sources.list
                        Press any key to edit the sources.list.
"
sudo nano /etc/apt/sources.list

# Update the package list and upgrade existing packages
sudo apt update
sudo apt upgrade -y

sudo dpkg --add-architecture i386

# Install necessary dependencies
sudo apt install -y build-essential software-properties-common apt-transport-https ufw gsmartcontrol fakeroot xdg-utils xdg-user-dirs synaptic
sudo apt install -y gnome-disk-utility mtools f2fs-tools xfsdump gvfs python3 python3-pip xserver-xorg-video-fbdev
clear

echo "Wayland support"
sleep 1
sudo apt install wayland xwayland
clear

# "Liquorix Kernel"
curl -s 'https://liquorix.net/install-liquorix.sh' | sudo bash
clear


# Add the WineHQ repository
sudo mkdir -pm755 /etc/apt/keyrings
wget -O - https://dl.winehq.org/wine-builds/winehq.key | sudo gpg --dearmor -o /etc/apt/keyrings/winehq-archive.key -
sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources
clear

# Update the package list again after adding new repositories
sudo apt update

# Install some needed packages
sudo apt install -y libglw1-mesa mesa-opencl-icd mesa-utils vulkan-tools vulkan-validationlayers
sudo apt install -y thunderbird celluloid strawberry
sudo apt install -y firefox

# Install multimedia codecs
sudo apt install -y \
    libavcodec-extra \
    gstreamer1.0-fdkaac \
    gstreamer1.0-vaapi \
    gstreamer1.0-pipewire \
    pipewire-v4l2 \
    pipewire-libcamera \
    lame \
	flac


sudo apt install -y  --install-recommends winehq-stable winetricks wine-binfmt libvkd3d1 libvkd3d-utils1
sudo apt install -y steam protontricks libgdiplus libfaudio0 ttf-mscorefonts-installer

# Install yt-dlp using pip
pip3 install -U yt-dlp

# Install Virt-Manager
sudo apt install -y virt-manager libvirt-daemon-system libvirt-clients qemu-kvm
sudo usermod -aG libvirt $(whoami)
sudo systemctl enable libvirtd


# Install Flatpak
sudo apt install -y flatpak xdg-desktop-portal xdg-desktop-portal-gtk

# Add the Flathub repository (where most Flatpak apps are hosted)
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo


# Enable ufw
sudo ufw enable

# Enable trim for SSD/NVMe
sudo systemctl enable fstrim.timer
sudo fstrim -av


# Clean up
sudo apt autoremove -y
sudo apt autoclean
sudo apt clean

echo ""
echo "----------------------------------------------"
echo "       Postconfig is now complete.            "
echo "                 Have fun !!                  "
echo "----------------------------------------------"
echo ""
read -p "..Press any key to reboot the System.."
clear
echo ""
echo "Reboot.."
sleep 2
sudo reboot
