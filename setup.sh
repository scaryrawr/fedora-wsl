#!/usr/bin/env sh

# Remove no docs flag
sed -i '/nodocs/d' /etc/dnf/dnf.conf

# Install packages required for a more "expected" experience
dnf install -y wget curl sudo ncurses dnf-plugins-core dnf-utils passwd findutils cracklib-dicts glibc-locale-source glibc-langpack-en which git-lfs vim PackageKit-command-not-found

# Get developer tools
dnf groupinstall -y 'Development Libraries' 'Development Tools'

# RPM Fusion
dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf groupupdate -y core
dnf groupupdate -y multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
dnf groupupdate -y sound-and-video
dnf update -y

dnf copr enable scaryrawr/mesa-d3d12 -y
dnf install -y mesa-dri-drivers mesa-d3d12 glx-utils

username=$1

if [ -z "$username" ]; then
    echo "Please enter a new user name: "
    read username
fi

useradd -m -G adm,wheel,dialout,cdrom,floppy,audio,video $username
passwd $username
