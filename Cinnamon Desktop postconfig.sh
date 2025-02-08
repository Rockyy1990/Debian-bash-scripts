#!/usr/bin/env bash

echo ""
echo "Postconfig after Cinnamon Desbian Desktop install (with netinstaller)"
echo "Read this script before execute !!"
sleep 2
read -p "Press any key to continue.."
clear

sudo dpkg --add-architecture i386
sudo apt update -y
sudo apt install -y software-properties-common
sudo apt-add-repository --component contrib non-free non-free-firmware
sudo apt update -y

# Remove unneeded packages
sudo apt autoremove -y pidgin hexchat rhythmbox remmina 
sudo apt autoremove -y gnome-games quadrapassel gnome-sudoku gnome-mahjongg gnome-chess iagno four-in-a-row lightsoff

sudo apt dist-upgrade -y

clear
echo ""

# System Packages
sudo apt install -y build-essential fakeroot git curl wget aria2 winbind gsmartcontrol flatpak ufw hdparm amd64-microcode fwupd linux-headers-amd64
sudo apt install -y gnome-disk-utility xfsdump ntfs-3g libfsntfs1 mtools fuse gvfs exfat-fuse jfsutils
sudo apt install -y xdg-desktop-portal xdg-desktop-portal-gtk xdg-user-dirs
sudo apt install -y libvulkan1 vulkan-validationlayers libvkd3d-shader1 libvkd3d-utils1

ufw enable
xdg-user-dirs-update


# Flatpak config
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak update
clear


# Multimedia
sudo apt install -y vlc strawberry lame twolame flac ffmpeg x264 x265 libmad0 sox libsoxr0 libsox-fmt-all soundconverter
sudo apt install -y gstreamer1.0-libcamera gstreamer1.0-libav gstreamer1.0-vaapi gstreamer1.0-fdkaac gstreamer1.0-plugins-bad gstreamer1.0-plugins-good gstreamer1.0-plugins-ugly 
sudo apt install -y pipewire-v4l2 gstreamer1.0-pipewire pipewire-libcamera libpipewire-0.3-modules-x11


# More Packages
sudo apt install -y thunderbird gthumb gthumb-data libreoffice timeshift obs-studio mintstick

# Printing Support
sudo apt install -y cups cups-filters printer-driver-gutenprint printer-driver-escpr ghostscript system-config-printer system-config-printer-udev
sudo systemctl enable cups


echo ""
echo "Install Discord"
echo ""
wget "https://discord.com/api/download?platform=linux&format=deb" -O discord.deb
sudo apt install -y ./discord.deb
sudo rm ./discord.deb
clear


echo ""
echo "Download yt-dlp"
echo "After this you can use yt-dlp over terminal"
sleep 3
wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -O yt-dlp

# Make it executable
chmod +x yt-dlp

# Move it to a desired location (optional)
mv yt-dlp /usr/local/bin/
clear


echo ""
read -p "Do you want to install Xanmod Kernel? (y/n): " answer

# Check user's response
if [ "$answer" = "y" ]; then
    echo "Installing Xanmod Kernel ..."
    # Add commands here to Install Xanmod Kernel
    sudo apt install -y software-properties-common apt-transport-https ca-certificates
    curl -fSsL https://dl.xanmod.org/gpg.key | gpg --dearmor | sudo tee /usr/share/keyrings/xanmod.gpg > /dev/null
    echo 'deb [signed-by=/usr/share/keyrings/xanmod.gpg] http://deb.xanmod.org releases main' | sudo tee /etc/apt/sources.list.d/xanmod-kernel.list
    sudo apt update
    sudo apt install -y linux-xanmod-x64v3
	#sudo apt install -y linux-xanmod-lts-x64v3

   echo "Xanmod Kernel installation complete."

elif [ "$answer" = "n" ]; then
    echo "Skipping Xanmod Kernel installation."

else
    echo "Invalid response. Please enter either 'y' or 'n'."

fi

sleep 2
clear

# NVIDIA
sudo apt install -y nvidia-driver nvidia-settings nvidia-opencl-icd firmware-misc-nonfree 
sudo apt install -y libnvidia-ngx libnvjpeg11 libxnvctrl0 
clear

echo ""
read -p "Edit grub: /etc/default/grub

nouveau.modeset=0 nvidia-drm.modeset=1

If you finish press any key to continue..

"

echo ""
flatpak install -y flathub com.github.tchx84.Flatseal                       # Flatpak rights management.
flatpak install -y flathub net.waterfox.waterfox                            # Optimized firefox Browser

clear


# Config Cinnamon Desktop
#gsettings set org.cinnamon.desktop.interface cursor-theme 'Qogir-Cursors'
#gsettings set org.cinnamon.desktop.interface gtk-theme 'Arc-Dark'
#gsettings set org.cinnamon.desktop.interface icon-theme 'Papirus-Dark'
#gsettings set org.cinnamon.theme name 'Arc-Dark'

# Download Cinnamon theme and icons deb
aria2c http://packages.linuxmint.com/pool/main/m/mint-themes/mint-themes_2.1.6_all.deb
aria2c http://packages.linuxmint.com/pool/main/m/mint-l-theme/mint-l-theme_1.9.6_all.deb
aria2c http://packages.linuxmint.com/pool/main/m/mint-x-icons/mint-x-icons_1.6.5_all.deb
aria2c http://packages.linuxmint.com/pool/main/m/mint-l-icons/mint-l-icons_1.6.7_all.deb
aria2c http://packages.linuxmint.com/pool/main/m/mint-cursor-themes/mint-cursor-themes_1.0.2_all.deb 
aria2c http://packages.linuxmint.com/pool/main/m/mint-backgrounds-ulyana/mint-backgrounds-ulyana_1.1_all.deb
aria2c http://packages.linuxmint.com/pool/main/m/mint-backgrounds-victoria/mint-backgrounds-victoria_1.2_all.deb


# Install the downloaded packages
sudo gdebi mint-themes_2.1.6_all.deb mint-l-theme_1.9.6_all.deb mint-x-icons_1.6.5_all.deb mint-l-icons_1.6.7_all.deb 
sudo gdebi mint-cursor-themes_1.0.2_all.deb mint-backgrounds-ulyana_1.1_all.deb mint-backgrounds-victoria_1.2_all.deb

# Apply the theme and icons
gsettings set org.cinnamon.theme name "Mint-L"
gsettings set org.cinnamon.desktop.interface icon-theme "Mint-L"


### Gedit
gsettings set org.gnome.gedit.plugins active-plugins "['wordcompletion', 'multiedit', 'colorpicker', 'codecomment', 'charmap', 'bracketcompletion', 'spell', 'sort', 'quickopen', 'quickhighlight', 'modelines', 'filebrowser', 'docinfo']"
gsettings set org.gnome.gedit.preferences.editor display-line-numbers true
gsettings set org.gnome.gedit.preferences.editor use-default-font false
gsettings set org.gnome.gedit.preferences.editor editor-font 'JetBrainsMono Nerd Font 12'
gsettings set org.gnome.gedit.preferences.editor scheme 'arc-dark'
gsettings set org.gnome.gedit.preferences.editor highlight-current-line true
gsettings set org.gnome.gedit.preferences.editor wrap-mode 'none'

clear

# Update Grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
clear

sudo apt install -f
sudo apt --fix-broken install -y
sudo apt autoremove -y
sudo apt autoclean -y
sudo apt purge -y
clear

sudo fstrim -av
sudo systemctl enable fstrim.timer

# Activate Disk Cache
sudo hdparm -W 1 /dev/sdc        # change sdc to the right disk (sda etc)


clear
echo "INFO: With timeshift you can restore the system over a livecd/usb if the hostsystem is not booting. "
sleep 2
echo ""
echo "Postconfig is complete"
read -p "Press any key to reboot ..."
sudo reboot
