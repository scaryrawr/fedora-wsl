#!/usr/bin/env sh

username=$1

if [ -z "$username" ]; then
    echo "Please enter a new user name: "
    read username
fi

useradd -m -G adm,wheel,dialout,cdrom,floppy,audio,video $username
passwd $username
