# Download Cloud Image
Invoke-WebRequest -Uri https://github.com/fedora-cloud/docker-brew-fedora/raw/33/x86_64/fedora-33.20210217-x86_64.tar.xz -OutFile Fedora.tar.xz

# Extract
7z e .\Fedora.tar.xz

# Make distro folder
if (!(Test-Path "$HOME\Distros\Fedora")) {
    mkdir $HOME\Distros\Fedora
}

# Import cloud image
wsl --import Fedora $HOME\Distros\Fedora .\Fedora.tar

# Launch to configure
wsl -d Fedora