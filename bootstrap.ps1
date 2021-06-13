#Requires -Version 5

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

# https://raw.githubusercontent.com/rajasoun/win10x-onboard/main/src/lib/system.ps1
$core_url = 'https://git.io/JZFdk'
Write-Output 'Initializing System Functions...'
Invoke-Expression (new-object net.webclient).downloadstring($core_url)
$workspace_url = 'https://git.io/JZAuo'
Write-Output 'Initializing Workspace Functions...'
Invoke-Expression (new-object net.webclient).downloadstring($workspace_url)
_Bootstrap
