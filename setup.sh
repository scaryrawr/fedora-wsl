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

# Install Mesa drivers and libraries for WSLg
dnf install -y mesa-dri-drivers mesa-libEGL mesa-libOpenCL mesa-libGLU mesa-libGL mesa-libOSMesa mesa-li
bd3d mesa-libgbm mesa-libglapi mesa-libxatracker mesa-omx-drivers mesa-vdpau-drivers mesa-vulkan-drivers

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
