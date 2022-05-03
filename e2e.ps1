#Requires -Version 5

param(
    [Parameter(Mandatory)]
    # app, hyperv, wsl 
    [String]$type 
)

# remote install:
$old_erroractionpreference = $erroractionpreference
$erroractionpreference = 'stop' # quit if anything goes wrong

if (($PSVersionTable.PSVersion.Major) -lt 5) {
    Write-Output "PowerShell 5 or later is required to run."
    Write-Output "Upgrade PowerShell: https://docs.microsoft.com/en-us/powershell/scripting/setup/installing-windows-powershell"
    break
}

if ([System.Enum]::GetNames([System.Net.SecurityProtocolType]) -notcontains 'Tls12') {
    Write-Output "Automator requires at least .NET Framework 4.5"
    Write-Output "Please download and install it first:"
    Write-Output "https://www.microsoft.com/net/download"
    break
}

$GIT_BASE_URL='https://raw.githubusercontent.com/rajasoun/win10x-onboard/main/src/lib'
Invoke-Expression (new-object net.webclient).downloadstring("$GIT_BASE_URL/common.ps1")
Invoke-Expression (new-object net.webclient).downloadstring("$GIT_BASE_URL/log.ps1")
Invoke-Expression (new-object net.webclient).downloadstring("$GIT_BASE_URL/Workspace.ps1")
Invoke-Expression (new-object net.webclient).downloadstring("$GIT_BASE_URL/Apps.Installer.ps1")
Invoke-Expression (new-object net.webclient).downloadstring("$GIT_BASE_URL/HyperV.ps1")
Invoke-Expression (new-object net.webclient).downloadstring("$GIT_BASE_URL/Wsl.ps1")

if($type -eq "apps"){
    $dir="$HOME/workspace/on-board/"
    info "Workspace Setup"
    Bootstrap-Env 
    info "Installating Applications for Current User"
    Install-Apps
}

if($type -eq "hyperv"){
    info "HyperV Setup"
    Enable-HyperV-IfNotDone
}

if($type -eq "wsl"){
    info "WSL2 Setup"
    Enable-Wsl-IfNotDone
    Wsl2-KernalUpdate
}

if($type -eq "system"){
    info "HyperV Setup"
    Enable-HyperV-IfNotDone
    info "WSL2 Setup"
    Enable-Wsl-IfNotDone
    Wsl2-KernalUpdate
}







