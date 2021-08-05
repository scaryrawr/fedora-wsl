# Fedora Importer

This helps set up Fedora on WSL, works on WSL 1 & 2. Based on [this article](https://fedoramagazine.org/wsl-fedora-33/).

## Requirements

- [7zip](https://www.7-zip.org/download.html) - Please add it to your `PATH` environment variable.

## Installing

### Default Setup

```powershell
.\setup.ps1
```

### Passing new User Name as parameter

```powershell
.\setup.ps1 -UserName userName
```

### Setting a custom Distro Name for WSL

```powershell
.\setup.ps1 -DistroName CustomName
```

### Setting a custom install directory

```powershell
# Will cause it to be installed at V:\Custom\Path\Fedora
.\setup.ps1 -InstallDirectory V:\Custom\Path
```