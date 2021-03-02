#!/usr/bin/env sh

dnf --setopt=install_weak_deps=False update
dnf --setopt=install_weak_deps=False install wget curl sudo ncurses dnf-plugins-core dnf-utils passwd findutils cracklib-dicts glibc-locale-source glibc-langpack-en which

username=$1

if [ -z "$username" ]; then
    echo "Please enter a new user name: "
    read username
fi

useradd -G wheel $username
passwd $username
