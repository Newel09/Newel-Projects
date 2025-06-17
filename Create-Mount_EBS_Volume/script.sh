# Check for the new volume
lsblk

# Format the volume (volume-name = nvme1n1 NB: yours might be different, copy it when you run the "lsblk")
sudo mkfs -t ext4 /dev/nvme1n1

# Create a mount point
sudo mkdir /mnt/mydata

# Mount the volume
sudo mount /dev/nvme1n1 /mnt/mydata

# (Optional) Get UUID for fstab
sudo blkid /dev/nvme1n1

# (Optional) Edit fstab to mount on reboot
sudo nano /etc/fstab
# Add line: UUID=xxxx /mnt/mydata ext4 defaults,nofail 0 2
