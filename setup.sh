#!/usr/bin/env sh

# Remove no docs flag
sed -i '/nodocs/d' /etc/dnf/dnf.conf

dnf update -y

# Install packages required for a more "expected" experience
dnf install -y wget curl sudo ncurses dnf-plugins-core dnf-utils passwd findutils cracklib-dicts glibc-locale-source glibc-langpack-en which git-lfs vim PackageKit-command-not-found mesa-dri-drivers glx-utils

# Get developer tools
dnf groupinstall -y 'Development Libraries' 'Development Tools'

# RPM Fusion
dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf groupupdate -y core
dnf groupupdate -y multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
dnf groupupdate -y sound-and-video

./systemd-setup.sh
./setup-xwayland.sh

username=$1

if [ -z "$username" ]; then
    echo "Please enter a new user name: "
    read username
fi

useradd -G wheel $username
passwd $username
