# Set default user as first non-root user
Get-ItemProperty Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Lxss\*\ DistributionName | Where-Object -Property DistributionName -eq Rawhide  | Set-ItemProperty -Name DefaultUid -Value 1000
