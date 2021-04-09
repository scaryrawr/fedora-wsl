# Download Cloud Image
Invoke-WebRequest -Uri https://github.com/fedora-cloud/docker-brew-fedora/raw/33/x86_64/fedora-33.20210401-x86_64.tar.xz -OutFile Fedora.tar.xz

# Extract
7z e .\Fedora.tar.xz

# Make distro folder
if (!(Test-Path "$HOME\AppData\Local\Fedora")) {
    mkdir $HOME\AppData\Local\Fedora
}

# Import cloud image
wsl --import Fedora $HOME\AppData\Local\Fedora .\Fedora.tar

# Launch to configure
wsl -d Fedora