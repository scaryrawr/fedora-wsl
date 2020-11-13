# Fedora Importer

This helps set up Fedora on WSL, works on WSL 1 & 2. Based on [this article](https://fedoramagazine.org/wsl-fedora-33/).

## Requirements

- 7zip

## Setup

1. Run `setup.ps1` this will download Fedora cloud image and launch you into fedora as root
2. Run `setup.sh USERNAME` while root in Fedora to create your Linux account
3. Run `exit` in Fedora to come back into Windows PowerShell
4. Run `finalize.ps1` to set default user to the created non-root user