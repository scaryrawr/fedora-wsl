# Download Cloud Image
Invoke-WebRequest -Uri https://github.com/fedora-cloud/docker-brew-fedora/raw/34/x86_64/fedora-Rawhide.20201230-x86_64.tar.xz -OutFile Fedora.tar.xz

# Extract
7z e .\Fedora.tar.xz

# Make distro folder
mkdir "$HOME\Distros\Fedora (Rawhide)"

# Import cloud image
wsl --import Rawhide "$HOME\Distros\Fedora (Rawhide)" .\Fedora.tar

# Launch to configure
wsl -d Rawhide
