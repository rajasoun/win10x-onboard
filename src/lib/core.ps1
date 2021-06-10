#Requires -Version 5

function success($msg) {  write-host $msg -f darkgreen }
function info($msg) {  write-host " >  $msg" -f cyan }
function warn($msg) {  write-host " >  $msg" -f yellow }

Function Test-ModuleAvailable {
    param (
        [String]$Name
    )
    info "Check $Name Available"
    Return [Boolean](Get-InstalledModule -Name $Name -ErrorAction Ignore)
}

function _create_directory($dir){
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
}

function _change_location($dir){
    Set-Location -Path $dir 
}

function _install_module($module){
    if(!(Test-ModuleAvailable $module)) {
        info "Installing $module"
        Install-Module -Name $module -Force -SkipPublisherCheck
        Import-Module $module
        info "$module Installation Done !!!"
    } else {
        warn "$module Already Installed !!!. Skipping"
    }
}

function _download($url){
    $download_zip_file = $(Split-Path -Path $url -Leaf) 
    Invoke-WebRequest -Uri $url -OutFile $download_zip_file
    info "Download $download_zip_file to $dir Done !!!"
}

function _unzip($file,$dir){
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory("$file",$dir)
    info "Unzip $file to $location Done !!!"
}

function _remove($item){
    if (Test-Path $item){
        Remove-Item $item -Force -Recurse
        info "$item Removal Done !!!"
    }
}

function _install_modules(){
    _install_module "PSReadLine" 
    _install_module "Pester"
}

function _get_bootstrap_scripts($url,$dir){
    _create_directory $dir
    _change_location $dir
    $download_zip_file = $(Split-Path -Path $url -Leaf)  
    info "Getting $download_zip_file From $url"
    _download($url)
    info "UnZip $download_zip_file"
    _unzip "$dir/$download_zip_file" "UnZip"
    info "Remove $download_zip_file"
    _remove($download_zip_file)
}

Function Bootstrap_HyperV 
{
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

Function Bootstrap_WSL 
{
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

Function Bootstrap_WSL2_KernalUpdate 
{
    Write-Host "Upgrade WSL Linux Kernel"
    if ([Environment]::Is64BitOperatingSystem)
    {
        Write-Host "System is x64. Need to update Linux kernel..."
        if (-not (Test-Path wsl_update_x64.msi))
        {
            Write-Host "Downloading Linux kernel update package..."
            Invoke-WebRequest -OutFile wsl_update_x64.msi https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi
        }
        Write-Host "Installing Linux kernel update package..."
        Start-Process msiexec.exe -Wait -ArgumentList '/I wsl_update_x64.msi /quiet'
        Write-Host "Linux kernel update package installed."
    }
    Write-Host "WSL is enabled. Setting it to WSL2"
    wsl --set-default-version 2
    Write-Host "WSL2 is enabled with Linux Kernal Upgrade. SUCCESS !!!"
}

Function GenerateFolder($path) 
{
    $global:foldPath = $null
    foreach($foldername in $path.split("\")) {
        $global:foldPath += ($foldername+"\")
        if (!(Test-Path $global:foldPath)){
            New-Item -ItemType Directory -Path $global:foldPath
            Write-Host "$global:foldPath Folder Created Successfully"
        }
    }
}

Function Bootstrap_Docker {

    Write-Host "Docker Installation..." 
    GenerateFolder "~/AppData/Roaming/Docker/"
    if (-not (Test-Path DockerInstaller.exe))
    {
        Write-Host "Installing Docker."            
        Write-Host "Downloading the Docker exe"
        Invoke-WebRequest -Uri https://desktop.docker.com/win/stable/Docker%20Desktop%20Installer.exe -OutFile DockerInstaller.exe -UseBasicParsing
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
        $ErrorActionPreference = 'SilentlyContinue';
        do { $var1 = docker ps 2>$null } while (-Not $var1)
        $ErrorActionPreference = 'Stop';
        $env:Path += ";C:\Program Files\Docker\Docker\Resources\bin"
        $env:Path += ";C:\Program Files\Docker\Docker\Resources"
        Write-Host "Docker Started successfully"       
}

function bootstrap_env(){
    _get_bootstrap_scripts $url $dir
    _install_modules
    success "Bootstrap Done!"
}

function admin_hyperv_wsl_docker_bootstrap(){
    Set-Executionpolicy -scope CurrentUser -executionPolicy Bypass -Force
    Bootstrap_HyperV
    Bootstrap_WSL 
    Bootstrap_WSL2_KernalUpdate
    Bootstrap_Docker
}

function applications_installer(){
    # Install Apps - Run In PowerShell 
    # NOTE: DO NOT Run this script as Administrator

    # Scoop Installation
    Set-Executionpolicy -scope CurrentUser -executionPolicy Bypass -Force
    iwr -useb get.scoop.sh | iex

    # Git Bash Installation
    scoop install Git

    scoop bucket add extras
    scoop update
    scoop install vscode
}

function applications_uninstaller(){
    Set-Executionpolicy -scope CurrentUser -executionPolicy Bypass -Force

    scoop uninstall vscode
    scoop uninstall Git

    scoop uninstall scoop
    del .\scoop -Force
}