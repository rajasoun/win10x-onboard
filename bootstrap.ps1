#Requires -Version 5

Function Test-IsAdmin{
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal $identity
    $principal.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

# remote install:
#   Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
$old_erroractionpreference = $erroractionpreference
$erroractionpreference = 'stop' # quit if anything goes wrong

if (($PSVersionTable.PSVersion.Major) -lt 5) {
    Write-Output "PowerShell 5 or later is required to run."
    Write-Output "Upgrade PowerShell: https://docs.microsoft.com/en-us/powershell/scripting/setup/installing-windows-powershell"
    break
}

# show notification to change execution policy:
$allowedExecutionPolicy = @('Unrestricted', 'RemoteSigned', 'ByPass')
if ((Get-ExecutionPolicy).ToString() -notin $allowedExecutionPolicy) {
    Write-Output "PowerShell requires an execution policy in [$($allowedExecutionPolicy -join ", ")] to run Scoop."
    Write-Output "For example, to set the execution policy to 'RemoteSigned' please run :"
    Write-Output "'Set-ExecutionPolicy RemoteSigned -scope CurrentUser'"
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
Invoke-Expression (new-object net.webclient).downloadstring("$GIT_BASE_URL/Docker.ps1")

If(-not(Test-IsAdmin)){
    $dir="$HOME/workspace/on-board/"
    info "Workspace Setup"
    $yn = Read-Host "Are you sure? (yN)"
    if ($yn -like 'y*') { 
        _Bootstrap_Env 
    }
}else{
    error "Skipping Workspace Setup. Need to Run in Non Admin Powershell"
}

If(-not(Test-IsAdmin)){
    info "Applications Installation..."
    $yn = Read-Host "Are you sure? (yN)"
    if ($yn -like 'y*') { 
        _Install_Apps
    }
}else{
    error "Skipping Applications Installation. Need to Run in Non Admin Powershell"
}

If((Test-IsAdmin)){
    info "HyperV,WSL2 and Docker Setup..."
    $yn = Read-Host "Are you sure? (yN)"
    if ($yn -like 'y*') { 
        Test-Enable-HyperV
        Test-Enable-Wsl2
        Wsl2-KernalUpdate
        _Install_Docker
    }
}else{
    error "Skipping HyperV,WSL2 and Docker Setup. Need to Run in as Admin Powershell"
}







