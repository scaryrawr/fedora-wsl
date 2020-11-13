#!/usr/bin/env bash

dnf update
dnf install wget curl sudo ncurses dnf-plugins-core dnf-utils passwd findutils cracklib-dicts glibc-locale-source glibc-langpack-en procps-ng util-linux-user 
dnf group install "Development Tools"

echo $1

useradd -G wheel $1
passwd $1