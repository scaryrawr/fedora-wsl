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
    $Version = "37"
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
$wslVersion = (Get-AppxPackage -name 'MicrosoftCorporationII.WindowsSubsystemForLinux').Version

$nixPath = wsl -e wslpath "$scriptDir"

# Launch to configure
wsl -d "$DistroName" "$nixPath/setup.sh" $UserName

# Set default user as first non-root user
Get-ItemProperty Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss\*\ DistributionName | Where-Object -Property DistributionName -eq "$DistroName"  | Set-ItemProperty -Name DefaultUid -Value 1000

# Version 0.67.6.0 and newer support systemd by default
if ($wslVersion -lt '0.67.6.0') {
    wsl -u root -d "$DistroName" "$nixPath/systemd-setup.sh"

    # Update Windows Terminal Profiles
    $guid = (New-Guid).Guid.ToString()
    @(
        # Stable
        "$HOME/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState", 

        # Preview
        "$HOME/AppData/Local/Packages/Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe/LocalState"
    ) | ForEach-Object {
        $terminalDir = "$_"
        $terminalProfile = "$terminalDir/settings.json"

        # This version of windows terminal isn't installed
        if (!(Test-Path $terminalProfile)) {
            return
        }

        # Load existing profile
        $configData = (Get-Content -Path $terminalProfile | ConvertFrom-Json) | Where-Object { $_ -ne $null }

        # Create a new list to store profiles
        $profiles = New-Object Collections.Generic.List[Object]

        $configData.profiles.list | Where-Object { $_.name -ne "${DistroName}" } | ForEach-Object { $profiles.Add($_) }
        $profiles.Add(@{
                commandline = "C:\WINDOWS\system32\wsl.exe -d ${DistroName} --cd ~ -e /usr/libexec/nslogin /bin/bash"
                name        = "${DistroName}"
                hidden      = $false
                guid        = "{$guid}"
                icon        = 'ms-appx:///ProfileIcons/{9acb9455-ca41-5af7-950f-6bca1bc9722f}.png'
            })
    
        # Update color schemes
        $configData.profiles.list = $profiles

        # Write config to disk
        $configData | ConvertTo-Json -Depth 32 | Set-Content -Path $terminalProfile
    }
}
else {
    wsl -u root -d "$DistroName" "$nixPath/systemd-enable.sh"
}

wsl -u root -d "$DistroName" "$nixPath/setup-user-runtime.sh"
wsl -u root -d "$DistroName" "$nixPath/setup-xwayland.sh"

# Terminate for launching with systemd support
wsl -t "${DistroName}"