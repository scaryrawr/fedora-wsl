param(
    # Name to give the new user
    [string]
    $UserName,
    # Name to register as
    [string]
    $DistroName = 'Fedora',
    # Install Location
    [string]
    $InstallDirectory = "$HOME\AppData\Local\",
    # Fedora version to install
    [string]
    [ValidateScript(
        { $_ -in (((Invoke-WebRequest -Uri https://api.github.com/repos/fedora-cloud/docker-brew-fedora/branches).Content | ConvertFrom-Json).name | Where-Object { $_ -match "^\d+$" }) },
        ErrorMessage = 'Invalid Fedora Version, please check available branches https://github.com/fedora-cloud/docker-brew-fedora/branches'
    )]
    $Version = "39"
)

# Determine ARM64 or x86_64
$arch = 'x86_64'
if ("$env:PROCESSOR_ARCHITECTURE" -eq 'ARM64') {
    $arch = 'aarch64'
}

$scriptDir = Split-Path $PSCommandPath

# Download Cloud Image
if (!(Test-Path "$scriptDir\Fedora-${Version}.tar.xz")) {
    Invoke-WebRequest -Uri "https://github.com/fedora-cloud/docker-brew-fedora/raw/${Version}/${arch}/fedora-${Version}-${arch}.tar.xz" -OutFile "$scriptDir\Fedora-${Version}.tar.xz" -ErrorAction Stop
}

# Extract
if (!(Test-Path "$scriptDir\Fedora-${Version}.tar")) {
    7z e "$scriptDir\Fedora-${Version}.tar.xz" -o"$scriptDir\"
}

# Make distro folder
if (!(Test-Path "$InstallDirectory\$DistroName")) {
    mkdir "$InstallDirectory\$DistroName"
}

# Import cloud image
wsl --import "$DistroName" "$InstallDirectory\$DistroName" "$scriptDir\Fedora-${Version}.tar"

$nixPath = wsl -e wslpath "$scriptDir"

# Launch to configure
wsl -d "$DistroName" "$nixPath/setup.sh" $UserName

# Set default user as first non-root user
Get-ItemProperty Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss\*\ DistributionName | Where-Object -Property DistributionName -eq "$DistroName"  | Set-ItemProperty -Name DefaultUid -Value 1000

# Terminate for launching with systemd support
wsl -t "${DistroName}"
