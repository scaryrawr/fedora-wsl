# Fedora Importer

This helps set up Fedora on WSL, works on WSL 2. Based on [this article](https://fedoramagazine.org/wsl-fedora-33/).

Works with x64 and ARM64 Windows

Please make sure to read all scripts and use at your own risk.

Things that this script does:

- Download the Fedora Docker Image and import it into WSL
- Setups systemd support
  - For older versions of WSL2 this involves building and installing https://github.com/ubuntu/wsl-setup
  - For newer versions it uses WSL2's built systemd support flag
- Configures RPM Fusion free and non-free
- Enables a custom copr for MESA D3D12 support scaryrawr/mesa-d3d12 and installs mesa drivers
- Does some configuration and package installs to get similar behavior to a normal-ish Fedora install

## Requirements

- [7zip](https://www.7-zip.org/download.html) - Please add it to your `PATH` environment variable.

## Installing

Once your path is correctly setup, you can do something like:

```powershell
.\setup.ps1 -Version 37 -UserName scaryrawr -DistroName Fed
```

Will install Fedora 37 and with the user scaryrawr. Password prompt will happen during the install process.

- The virtual hard disk will exist at: `%LOCALAPPDATA%\Fed\ext4.vhdx`
- Running `wsl -l` should output something like:

  ```txt
  Windows Subsystem for Linux Distributions:
  Fed (Default)
  ```

### Default Setup

```powershell
.\setup.ps1
```

### Specifying Fedora Version

```powershell
.\setup.ps1 -Version 37
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

Default installation directory is `%LOCALAPPDATA%\Fedora`. You may want to specify a custom install location
if you have a separate drive/partition.

```powershell
# Will cause it to be installed at V:\Custom\Path\Fedora
.\setup.ps1 -InstallDirectory V:\Custom\Path
```
