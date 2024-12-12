#!/usr/bin/env sh

while getopts u:p:l: flag
do
    case "${flag}" in
        u) username=${OPTARG};;
        p) password=${OPTARG};;
        l) language=${OPTARG};;
    esac
done

if [ -z "$username" ]; then
    echo "Please enter a new user name: "
    read username
fi

useradd -m -G adm,wheel,dialout,cdrom,floppy,audio,video $username

if [ -z "$password" ]; then
    passwd $username
else
    echo "$username:$password" | chpasswd
fi

if [ -n "$language" ]; then
    sudo dnf install -y "glibc-langpack-$language"
fi