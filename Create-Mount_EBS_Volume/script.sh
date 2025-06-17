#!/bin/bash

# List available block devices
lsblk

# Prompt user for the device name
read -p "Enter the device name (e.g., nvme1n1): " DEVICE

# Format the volume
sudo mkfs -t ext4 /dev/$DEVICE

# Create a mount point
sudo mkdir -p /mnt/mydata

# Mount the volume
sudo mount /dev/$DEVICE /mnt/mydata

# Display UUID information
sudo blkid /dev/$DEVICE

echo "If you want to mount automatically on reboot:"
echo "Edit /etc/fstab and add:"
UUID=$(sudo blkid -s UUID -o value /dev/$DEVICE)
echo "UUID=$UUID /mnt/mydata ext4 defaults,nofail 0 2"
