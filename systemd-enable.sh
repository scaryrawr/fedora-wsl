#!/usr/bin/env sh

# # We're building wsl-setup so we need systemd headers
# dnf install -y systemd-devel

# # Set up systemd
# git clone https://github.com/ubuntu/wsl-setup
# cd wsl-setup
# make
# make install

# cd ..
# rm -rf wsl-setup

# # Remove build dependencies
# dnf autoremove -y systemd-devel

# Set boot command for systemd to be pid 1
echo '[boot]
systemd=true' >> /etc/wsl.conf
