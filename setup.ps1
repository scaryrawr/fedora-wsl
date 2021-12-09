param(
        # Name to give the new user
        [string]$UserName,
        # Name to register as
        [string]$DistroName = 'Fedora',
        # Install Location
        [string]$InstallDirectory = "$HOME\AppData\Local\"
    )

# Determine ARM64 or x86_64
$arch = 'x86_64'
if ("$env:PROCESSOR_ARCHITECTURE" -eq 'ARM64') {
    $arch = 'aarch64'
}

$scriptDir = Split-Path $PSCommandPath

# Download Cloud Image
if (!(Test-Path "$scriptDir\Fedora.tar.xz")) {
    Invoke-WebRequest -Uri "https://github.com/fedora-cloud/docker-brew-fedora/raw/35/${arch}/fedora-35.20211125-${arch}.tar.xz" -OutFile "$scriptDir\Fedora.tar.xz" -ErrorAction Stop
}

# Extract
if (!(Test-Path "$scriptDir\Fedora.tar")) {
    7z e "$scriptDir\Fedora.tar.xz" -o"$scriptDir\"
}

# Make distro folder
if (!(Test-Path "$InstallDirectory\$DistroName")) {
    mkdir "$InstallDirectory\$DistroName"
}

# Import cloud image
wsl --import "$DistroName" "$InstallDirectory\$DistroName" "$scriptDir\Fedora.tar"

$nixPath = wsl -e wslpath "$scriptDir"
# Launch to configure
wsl -d "$DistroName" "$nixPath/setup.sh" $UserName

# Set default user as first non-root user
Get-ItemProperty Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss\*\ DistributionName | Where-Object -Property DistributionName -eq "$DistroName"  | Set-ItemProperty -Name DefaultUid -Value 1000