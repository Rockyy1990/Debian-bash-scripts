#!/usr/bin/env bash

# Last Edit: 11.02.2025

# Check if zenity is installed
if ! command -v zenity &> /dev/null; then
    echo "Zenity is not installed. Please install it using 'sudo apt install zenity'."
    exit 1
fi

# Get the list of installed kernels
kernels=$(dpkg --list | grep linux-image | awk '{print $2}' | sort)

# Check if there are any installed kernels
if [ -z "$kernels" ]; then
    zenity --info --text="No kernels are installed."
    exit 0
fi

# Create a selection dialog with the list of kernels
selected_kernel=$(echo "$kernels" | zenity --list --title="Select Kernel to Remove" --column="Installed Kernels" --height=400 --width=300 --multiple)

# Check if the user canceled the dialog
if [ $? -ne 0 ]; then
    exit 0
fi

# Confirm removal
zenity --question --text="Are you sure you want to remove the selected kernel(s)?"
if [ $? -ne 0 ]; then
    exit 0
fi

# Remove the selected kernel(s)
for kernel in $selected_kernel; do
    sudo apt-get purge -y "$kernel"
done

# Inform the user of the successful removal
zenity --info --text="Selected kernel(s) have been removed."

# Optionally, update the GRUB configuration
sudo update-grub