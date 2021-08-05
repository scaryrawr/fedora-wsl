#!/usr/bin/env sh

dnf update -y

# Install packages required for a more "expected" experience
dnf install -y wget curl sudo ncurses dnf-plugins-core dnf-utils passwd findutils cracklib-dicts glibc-locale-source glibc-langpack-en which git-lfs vim

# Get developer tools
dnf groupinstall -y 'Development Libraries' 'Development Tools'

# RPM Fusion
dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf groupupdate -y core
dnf groupupdate -y multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
dnf groupupdate -y sound-and-video

dnf copr enable yanqiyu/mesa -y
dnf install -y mesa-d3d12 mesa-dri-drivers mesa-libd3d mesa-libEGL mesa-libgbm mesa-libGL mesa-libOpenCL mesa-vdpau-drivers

dnf install -y glx-utils

# Remove "Container Image" strings so neofetch looks "cooler"
sed -i 's/ (Container Image)//g' /etc/os-release
sed -i '/^VARIANT/g' /etc/os-release

username=$1

if [ -z "$username" ]; then
    echo "Please enter a new user name: "
    read username
fi

useradd -G wheel $username
passwd $username
