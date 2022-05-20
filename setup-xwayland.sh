#!/usr/bin/env sh

# HACK: Configure link for xwayland socket
echo '#Type Path           Mode User Group Age Argument
L+    /tmp/.X11-unix -    -    -     -   /mnt/wslg/.X11-unix' >> /etc/tmpfiles.d/wsl2.conf