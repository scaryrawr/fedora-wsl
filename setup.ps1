param(
    # Name to give the new user
    [string]
    $UserName,
    # Name to register as
    [string]
    $DistroName = 'Fedora',
    # Install Location
    [string]
    $InstallDirectory = "$HOME\AppData\Local\"
)

# Determine ARM64 or x86_64
$arch = 'amd64'
if ("$env:PROCESSOR_ARCHITECTURE" -eq 'ARM64') {
    $arch = 'arm64'
}

$scriptDir = Split-Path $PSCommandPath

Invoke-WebRequest -Uri "https://github.com/scaryrawr/Fedora-WSL-RootFS/releases/latest/download/rootfs.${arch}.tar.gz" -OutFile "$scriptDir\Fedora${Version}.tar.gz" -ErrorAction Stop

# Make distro folder
if (!(Test-Path "$InstallDirectory\$DistroName")) {
    mkdir "$InstallDirectory\$DistroName"
}

# Import image
wsl --import "$DistroName" "$InstallDirectory\$DistroName" "$scriptDir\Fedora${Version}.tar.gz"

$nixPath = wsl -e wslpath "$scriptDir"

# Launch to configure
wsl -d "$DistroName" "$nixPath/setup.sh" $UserName

# Set default user as first non-root user
Get-ItemProperty Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss\*\ DistributionName | Where-Object -Property DistributionName -eq "$DistroName"  | Set-ItemProperty -Name DefaultUid -Value 1000

# Terminate for launching with systemd support
wsl -t "${DistroName}"
