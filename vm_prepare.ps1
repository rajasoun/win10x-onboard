#Requires -Version 5 

function Check-Command($cmdname){
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

if (-not(Check-Command -cmdname 'choco')) {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}else{
    choco upgrade chocolatey -y
    choco upgrade powershell-core -y 
    choco upgrade Pester -y 
}

# DISM /Online /Enable-Feature /All /FeatureName:Microsoft-Hyper-V
# Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All

# DISM /Online /Enable-Feature  /FeatureName:Microsoft-Windows-Subsystem-Linux /all /norestart
# DISM /Online /Enable-Feature  /FeatureName:VirtualMachinePlatform /all /norestart
# Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform 

# $URL='https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi'
# $destination='wsl_update_x64.msi'
# $progressPreference = 'silentlyContinue'
# Invoke-WebRequest -Uri $URL -OutFile $destination -ErrorAction Stop

# Start-Process msiexec.exe -Wait -ArgumentList '/I wsl_update_x64.msi /quiet'

# wsl --set-default-version 2

