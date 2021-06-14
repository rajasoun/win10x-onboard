#Requires -Version 5 -RunAsAdministrator

Function _Enable_HyperV {
    Write-Host "Checking if Hyper-V is enabled."
    $hyperv = Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online
    if($hyperv.State -eq "Enabled") {
        Write-Host "Hyper-V is enabled. SUCCESS !!!"
    } else {
        Write-Host "Hyper-V is Disabled."
        Write-Host "Enabling Hyper-V feature now"
        Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
        Start-Sleep 30
        Write-Host "Hyper-V is enabled now reboot the system and re-run the script to continue the installation."
    }
}

Function _Enable_WSL {
    Write-Host "Checking if WSL is enabled."
    $wsl = Get-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -Online
    if($wsl.State -eq "Enabled") {
        Write-Host "WSL is enabled. SUCCESS !!!"
    } else {
        Write-Host "WSL is disabled."
        Write-Host "Enabling WSL2 feature now"

        & cmd /c 'dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart'
        & cmd /c 'dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart'
        Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform
        Start-Sleep 30
        Write-Host "WSL is enabled now reboot the system and re-run the script to continue the installation."
    }
}

Function _WSL2_KernalUpdate {
    Write-Host "Upgrade WSL Linux Kernel"
    if ([Environment]::Is64BitOperatingSystem){
        Write-Host "System is x64. Need to update Linux kernel..."
        if (-not (Test-Path wsl_update_x64.msi)){
            Write-Host "Downloading Linux kernel update package..."
            $URL='https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi'
            $destination='wsl_update_x64.msi'
            $progressPreference = 'silentlyContinue'
            Invoke-WebRequest -Uri $URL -OutFile $destination -ErrorAction Stop
            $progressPreference = 'Continue'
        }
        Write-Host "Installing Linux kernel update package..."
        Start-Process msiexec.exe -Wait -ArgumentList '/I wsl_update_x64.msi /quiet'
        Write-Host "Linux kernel update package installed."
    }
    Write-Host "WSL is enabled. Setting it to WSL2"
    wsl --set-default-version 2
    Write-Host "WSL2 is enabled with Linux Kernal Upgrade. SUCCESS !!!"
}

Function _Install_Docker {

    Write-Host "Docker Installation..." 
    GenerateFolder "~/AppData/Roaming/Docker/"
    if (-not (Test-Path DockerInstaller.exe)){
        Write-Host "Installing Docker."            
        Write-Host "Downloading the Docker exe"
        $URL='https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe'
        $destination='DockerInstaller.exe'
        $progressPreference = 'silentlyContinue'
        Invoke-WebRequest -Uri $URL -OutFile $destination -ErrorAction Stop -UseBasicParsing
        $progressPreference = 'Continue'
        Write-Host "Download Completed"
        
        start-process .\DockerInstaller.exe "install --quiet" -Wait -NoNewWindow
        cd "C:\Program Files\Docker\Docker\"
        Write-Host "Installing Docker..."
        $ProgressPreference = 'SilentlyContinue'
        & '.\Docker Desktop.exe'
        $env:Path += ";C:\Program Files\Docker\Docker\Resources\bin"
        $env:Path += ";C:\Program Files\Docker\Docker\Resources"
        Write-Host "Docker Installed successfully"
        Write-Host "You must reboot the sytem to continue. After reboot re-run the script."
        Restart-Computer -Confirm 
    }
    Write-Host "Starting docker..."
    & 'C:\Program Files\Docker\Docker\DockerCli.exe' -SwitchDaemon
    $ErrorActionPreference = 'SilentlyContinue';
    do { $var1 = docker ps 2>$null } while (-Not $var1)
    $ErrorActionPreference = 'Stop';
    $env:Path += ";C:\Program Files\Docker\Docker\Resources\bin"
    $env:Path += ";C:\Program Files\Docker\Docker\Resources"
    Write-Host "Docker Started successfully"       
}

Function _Bootstrap(){
    # NOTE: Run this script as Administrator
    Set-Executionpolicy -scope CurrentUser -executionPolicy Bypass -Force
    _Enable_HyperV
    _Enable_WSL 
    _WSL2_KernalUpdate
    _Install_Docker
}