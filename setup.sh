#!/usr/bin/env sh

dnf update
dnf install wget curl sudo ncurses dnf-plugins-core dnf-utils passwd findutils cracklib-dicts glibc-locale-source glibc-langpack-en procps-ng util-linux-user PackageKit-command-not-found which
dnf group install "Development Tools"

username=$1

if [ -z "$username" ]; then
    echo "Please enter a new user name: "
    read username
fi

useradd -G wheel $username
passwd $username
