#Requires -Version 5 

. "$psscriptroot/log.ps1"
. "$psscriptroot/common.ps1"

function install_choco(){
    if((is_admin)){
        if (-not(Check-Command -cmdname 'choco')) {
            # NOTE: DO NOT Run this script as Administrator
            info "Installing choco"  
            Set-Executionpolicy -scope CurrentUser -executionPolicy Bypass -Force 
            [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
            iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
            success  "choco Installation Done. Success !!!" 
        }else{
            warn "choco already installed"
        }
    }else{
        abort("Pls. run the Script as Admin")
    }
}

function install_docker_desktop(){
    info  "Installing Docker Desktop"
    choco install docker-desktop -y

    info "Starting Docker..."
    & 'C:\Program Files\Docker\Docker\Docker Desktop.exe'
    $env:Path += ";C:\Program Files\Docker\Docker\Resources\bin"
    $env:Path += ";C:\Program Files\Docker\Docker\Resources"
    success  "Docker Desktop Installation Done. Success !!!" 

    info "Switching Docker to the Windows Daemon" 
    & 'C:\Program Files\Docker\Docker\DockerCli.exe' -SwitchDaemon
    # $ErrorActionPreference = 'SilentlyContinue';
    do { $var1 = docker ps 2>$null } while (-Not $var1)
    # $ErrorActionPreference = 'Stop';
    $env:Path += ";C:\Program Files\Docker\Docker\Resources\bin"
    $env:Path += ";C:\Program Files\Docker\Docker\Resources"
    success "Docker Started successfully"  
}

function _Install_Docker(){
    install_choco
    install_docker_desktop
}
