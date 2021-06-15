#Requires -Version 5 -RunAsAdministrator

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
    Write-Host  "Switching Docker to the Windows Daemon`n" -ForegroundColor Green
    & 'C:\Program Files\Docker\Docker\DockerCli.exe' -SwitchDaemon
    $ErrorActionPreference = 'SilentlyContinue';
    do { $var1 = docker ps 2>$null } while (-Not $var1)
    $ErrorActionPreference = 'Stop';
    $env:Path += ";C:\Program Files\Docker\Docker\Resources\bin"
    $env:Path += ";C:\Program Files\Docker\Docker\Resources"
    Write-Host "Docker Started successfully"       
}
