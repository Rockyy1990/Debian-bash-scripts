#!/usr/bin/env bash

# Last Edit: 11.02.2025

# Define color codes
ORANGE='\033[1;33m'  # Orange color
NC='\033[0m'         # No Color

echo -e "${ORANGE}"
echo ""
echo "----------------------------------------------"
echo "      ..Debian config after install..         "
echo "               Plasma Desktop                 "
echo "----------------------------------------------"
sleep 2
echo ""
echo "     !!!You should read this script first!!!"
echo -e "${NC}"  # Reset to no color

echo ""
read -p "Press any key to continue.." 
echo ""

# Remove unneeded packages
sudo apt autoremove -y juk dragonplayer gimp akregator
clear

echo ""
read -p "If not set: add contrib non-free non-free-firmware to the sources.list
                        Press any key to edit the sources.list.
"
sudo nano /etc/apt/sources.list
clear


# Update the package list and upgrade existing packages
sudo apt update
sudo apt upgrade -y

sudo dpkg --add-architecture i386

# Install necessary dependencies
sudo apt install -y build-essential dkms software-properties-common apt-transport-https ufw gsmartcontrol fakeroot xdg-utils xdg-user-dirs synaptic
sudo apt install -y gnome-disk-utility mtools f2fs-tools xfsdump gvfs python3 python3-pip xserver-xorg-video-fbdev
clear


## "Liquorix Kernel"
#curl -s 'https://liquorix.net/install-liquorix.sh' | sudo bash
#clear


# Xanmod Kernel
wget -qO - https://dl.xanmod.org/archive.key | sudo gpg --dearmor -vo /etc/apt/keyrings/xanmod-archive-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/xanmod-archive-keyring.gpg] http://deb.xanmod.org releases main' | sudo tee /etc/apt/sources.list.d/xanmod-release.list
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


# Wine and Steam Gaming Platform
sudo apt install -y  --install-recommends winehq-stable winetricks wine-binfmt libvkd3d1 libvkd3d-utils1
sudo apt install -y steam protontricks libgdiplus libfaudio0 libopenal1 ttf-mscorefonts-installer

echo ""
echo " Downloading Protonup-qt.."
sleep 3
wget https://github.com/DavidoTek/ProtonUp-Qt/releases/download/v2.11.1/ProtonUp-Qt-2.11.1-x86_64.AppImage
echo ""

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


# Install the Xanmod Kernel v3
sudo apt install linux-xanmod-x64v3


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
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow http  # Allows HTTP (port 80)
sudo ufw allow https # Allows HTTPS (port 443)


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
