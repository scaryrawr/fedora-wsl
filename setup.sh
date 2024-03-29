#!/usr/bin/env sh

# Remove no docs flag
sed -i '/nodocs/d' /etc/dnf/dnf.conf

# Enable systemd
echo '[boot]
systemd=true' >> /etc/wsl.conf

# Install packages required for a more "expected" experience
dnf install -y wget curl sudo ncurses dnf-plugins-core dnf-utils passwd findutils cracklib-dicts glibc-locale-source glibc-langpack-en which git-lfs vim PackageKit-command-not-found

# Get developer tools
dnf groupinstall -y 'Development Libraries' 'Development Tools'

# RPM Fusion
dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
dnf groupupdate -y core
dnf groupupdate -y multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
dnf groupupdate -y sound-and-video
dnf copr enable scaryrawr/mesa-d3d12 -y
dnf update -y
dnf install mesa-dri-drivers mesa-d3d12 mesa-vdpau-drivers -y

git clone https://github.com/scaryrawr/bottle-imp

cd bottle-imp

make internal-systemd
make internal-binfmt

cd ..
sudo rm -rf bottle-imp

username=$1

if [ -z "$username" ]; then
    echo "Please enter a new user name: "
    read username
fi

useradd -m -G adm,wheel,dialout,cdrom,floppy,audio,video $username
passwd $username
