#!/usr/bin/env bash

# Last Edit: 03.11.2025

# Define color codes
ORANGE='\033[1;33m'  # Orange color
NC='\033[0m'         # No Color

echo -e "${ORANGE}"
echo ""
echo "----------------------------------------------"
echo "      ..Debian config after install..         "
echo "               Gnome Desktop                  "
echo "----------------------------------------------"
sleep 2
echo ""
echo "     !!!You should read this script first!!!"
echo "Check the download link for nomachine. You must change it if its not the latest!"
echo -e "${NC}"  # Reset to no color

echo ""
read -p "Press any key to continue.." 
echo ""

echo ""
read -p "If not set: add - contrib non-free non-free-firmware - to the sources.list (without the - -)
                          Press any key to edit the sources.list.
"
sudo nano /etc/apt/sources.list
clear


sudo dpkg --add-architecture i386

sudo apt update
sudo apt upgrade -y
sudo apt dist-upgrade -y


# Install necessary dependencies
sudo apt install -y build-essential fakeroot dkms curl apt-transport-https ufw gsmartcontrol xdg-utils xdg-user-dirs synaptic
sudo apt install -y fuse libfuse2 libgtk-3-0 libglib2.0-0 libstdc++6
sudo apt install -y libwayland-egl++1 wayland-protocols libwlroots-0.18
sudo apt install -y gnome-disk-utility mtools f2fs-tools xfsdump gvfs gvfs-backends 
sudo apt install -y python3 
clear


# "Liquorix Kernel"
curl -s 'https://liquorix.net/install-liquorix.sh' | sudo bash
clear


# Download and install nomachine (remote desktop)
wget https://web9001.nomachine.com/download/9.2/Linux/nomachine_9.2.18_3_amd64.deb
sudo apt install ~/nomachine_9.2.18_3_amd64.deb
sudo rm ~/nomachine_9.2.18_3_amd64.deb

# Add the WineHQ repository
sudo mkdir -pm755 /etc/apt/keyrings
wget -O - https://dl.winehq.org/wine-builds/winehq.key | sudo gpg --dearmor -o /etc/apt/keyrings/winehq-archive.key -
sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/debian/dists/trixie/winehq-trixie.sources

# Update the package list again after adding new repositories
sudo apt update

# Install some needed packages
sudo apt install -y mesa-opencl-icd mesa-utils vulkan-tools vulkan-validationlayers 
sudo apt install -y thunderbird firefox-esr-l10n-de celluloid strawberry soundconverter mintstick


# Install multimedia codecs
sudo apt install -y libavcodec-extra gstreamer1.0-fdkaac gstreamer1.0-vaapi ffmpeg lame flac  
sudo apt install -y pipewire-v4l2 pipewire-libcamera gstreamer1.0-pipewire
         
	     


# Wine and Steam Gaming Platform
sudo apt install -y --install-recommends winehq-stable winetricks wine-binfmt libwinpr3-3 libvkd3d1 libvkd3d-utils1
sudo apt install -y --install-recommends steam-installer libgdiplus libfaudio0 ttf-mscorefonts-installer



# Define the path to the OpenAL configuration file
CONFIG_FILE="/etc/openal/alsoft.conf"

# Check if the configuration file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Configuration file not found: $CONFIG_FILE"
    exit 1
fi

# Enable HRTF by uncommenting the line in the configuration file
if grep -q "^#hrtf" "$CONFIG_FILE"; then
    sudo sed -i 's/^#hrtf = false/hrtf = true/' "$CONFIG_FILE"
    echo "HRTF has been enabled in $CONFIG_FILE."
else
    echo "HRTF is already enabled or not found in $CONFIG_FILE."
fi



# Install Virt-Manager
sudo apt install -y virt-manager libvirt-daemon-system libvirt-clients qemu-kvm
sudo usermod -aG libvirt $(whoami)
sudo systemctl enable libvirtd


# Install Flatpak
# sudo apt install -y flatpak node-xdg-basedir xdg-desktop-portal xdg-desktop-portal-gtk
# sudo apt install -y flatpak-xdg-utils gir1.2-flatpak-1.0 libportal1 

# Add the Flathub repository (where most Flatpak apps are hosted)
# sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# flatpak remove -y flathub com.github.tchx84.Flatseal
# flatpak remove -y flathub com.nomachine.nxplayer
# flatpak remove -y flathub fr.handbrake.ghb
# flatpak remove -y flathub net.davidotek.pupgui2


# Creates an virtual environment named myenv
# python3 -m venv myenv

# Activates the new environment and upgrades python pip
# source myenv/bin/activate
# python -m pip3 install --upgrade pip

# Installs yt-dlp
# pip3 install -U yt-dlp

# Creating a symlink to use yt-dlp system-wide
# sudo ln -s ~/myenv/bin/yt-dlp /usr/local/bin/yt-dlp

# Download yt-dlp directly from github. (latest)
wget https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp
chmod +x yt-dlp
sudo mv yt-dlp /usr/local/bin/

# Download AppImage Updater
wget https://github.com/AppImageCommunity/AppImageUpdate/releases/download/2.0.0-alpha-1-20251018/AppImageUpdate-x86_64.AppImage
chmod +x AppImageUpdate-x86_64.AppImage
mkdir ~/AppImages
mv AppImageUpdate-x86_64.AppImage ~/AppImages

# Download ProtonUp-Qt AppImage directly from github
wget https://github.com/DavidoTek/ProtonUp-Qt/releases/download/v2.14.0/ProtonUp-Qt-2.14.0-x86_64.AppImage
chmod +x ProtonUp-Qt-2.14.0-x86_64.AppImage
mv ProtonUp-Qt-2.14.0-x86_64.AppImage ~/AppImages


# Enable ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow http  # Allows HTTP (port 80)
sudo ufw allow https # Allows HTTPS (port 443)
sudo ufw allow 4000/tcp
sudo ufw allow 22/tcp
sudo ufw enable


# Set /etc/environment variables
echo -e "
CPU_LIMIT=0
CPU_GOVERNOR=performance
GPU_USE_SYNC_OBJECTS=1
PYTHONOPTIMIZE=1
ELEVATOR=kyber
TRANSPARENT_HUGEPAGES=always
MALLOC_CONF=background_thread:true
MALLOC_CHECK=0
MALLOC_TRACE=0
LD_DEBUG_OUTPUT=0
LP_PERF=no_mipmap,no_linear,no_mip_linear,no_tex,no_blend,no_depth,no_alphatest
LESSSECURE=1
PAGER=less
EDITOR=nano
VISUAL=nano
AMD_VULKAN_ICD=RADV
RADV_PERFTEST=aco,sam,nggc
RADV_DEBUG=novrsflatshading
GAMEMODE=1
vblank_mode=1
PROTON_LOG=0
PROTON_USE_WINED3D=0
PROTON_FORCE_LARGE_ADDRESS_AWARE=1
PROTON_NO_ESYNC=1
PROTON_USE_FSYNC=1
DXVK_ASYNC=1
WINE_FSR_OVERRIDE=1
WINE_FULLSCREEN_FSR=1
WINE_VK_USE_FSR=1
WINEFSYNC_FUTEX2=1
WINEFSYNC_SPINCOUNT=24
MESA_BACK_BUFFER=ximage
MESA_NO_DITHER=0
MESA_SHADER_CACHE_DISABLE=false
mesa_glthread=true
MESA_DEBUG=0
" | sudo tee -a /etc/environment


## Improve PCI latency
sudo setpci -v -d *:* latency_timer=48 >/dev/null 2>&1


# Enable tmpfs ramdisk
sudo sed -i -e '/^\/\/tmpfs/d' /etc/fstab
echo -e "
tmpfs /var/tmp tmpfs nodiratime,nodev,nosuid,mode=1777 0 0
tmpfs /var/log tmpfs nodiratime,nodev,nosuid,mode=1777 0 0
tmpfs /var/run tmpfs nodiratime,nodev,nosuid,mode=1777 0 0
tmpfs /var/lock tmpfs nodiratime,nodev,nosuid,mode=1777 0 0
tmpfs /var/cache tmpfs nodiratime,nodev,nosuid,mode=1777 0 0
tmpfs /var/volatile tmpfs nodiratime,nodev,nosuid,mode=1777 0 0
tmpfs /var/spool tmpfs nodiratime,nodev,nosuid,mode=1777 0 0
tmpfs /media tmpfs nodiratime,nodev,nosuid,mode=1777 0 0
tmpfs /dev/shm tmpfs nodiratime,nodev,nosuid,mode=1777 0 0
" | sudo tee -a /etc/fstab



# Enable trim for SSD/NVMe
sudo systemctl enable fstrim.timer
sudo fstrim -av


# Clean up
sudo apt purge -y
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
