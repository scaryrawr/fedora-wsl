# Determine ARM64 or x86_64
$arch = 'x86_64'
if ("$env:PROCESSOR_ARCHITECTURE" -eq 'ARM64') {
    $arch = 'aarch64'
}

# Download Cloud Image
Invoke-WebRequest -Uri "https://github.com/fedora-cloud/docker-brew-fedora/raw/34/${arch}/fedora-34.20210514-${arch}.tar.xz" -OutFile Fedora.tar.xz

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