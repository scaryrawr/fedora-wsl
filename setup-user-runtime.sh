#!/usr/bin/env sh

git clone https://github.com/scaryrawr/bottle-imp

cd bottle-imp

make internal-systemd

cd ..
rm -rf bottle-imp