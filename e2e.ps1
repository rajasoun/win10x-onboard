#Requires -Version 5

param(
    #[Parameter(Mandatory,HelpMessage='Installation Type [ apps | system ] ? ')]
    [Parameter()]
    [String]$type = 'bootstrap-apps'
)

# remote install:
$old_erroractionpreference = $erroractionpreference
$erroractionpreference = 'stop' # quit if anything goes wrong

if (($PSVersionTable.PSVersion.Major) -lt 5) {
    Write-Output "PowerShell 5 or later is required to run."
    Write-Output "Upgrade PowerShell: https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows"
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
Invoke-Expression (new-object net.webclient).downloadstring("$GIT_BASE_URL/Apps.Teardown.ps1")


if($type -eq "bootstrap-apps"){
    $dir="$HOME\workspace"
    info "Workspace Setup"
    Bootstrap-Env 
    info "Installating Bootstrap Applications (scoop, git & wget) for Current User"
    Install-BootstrapApps
}

if($type -eq "apps"){
    $dir="$HOME\workspace"
    info "Workspace Setup"
    Bootstrap-Env 
    info "Applications (vscode, gh, concfg, PowerSession) for Current User"
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

if($type -eq "teardown"){
    info "Teardown Terminal Setup, scoop and all Applications"
    Teardown-Apps
}

if($type -eq "elevate"){
    Start-Process powershell.exe -verb runAs -ArgumentList '-NoExit','-Command','cd ~\workspace\win10x-onboard'
}

if($type -eq "profile"){
    Profile-System
}

if($type -eq "bash-it"){
    Import-Alias -Path "alias.csv" -ErrorAction SilentlyContinue
    bash-it --login -i
}

if($type -eq "apps-setup-test"){
    Invoke-Pester e2e.Tests.ps1 -Tag "prerequisite"  -Output Detailed
    Invoke-Pester src\lib\Apps.Installer.Tests.ps1 -Output Detailed
}

if($type -eq "system-setup-test"){
    Invoke-Pester src\lib\HyperV.Tests.ps1 -Output Detailed
    Invoke-Pester src\lib\Wsl.Tests.ps1 -Output Detailed
}







