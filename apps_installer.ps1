#Requires -Version 5

$dir="$HOME/workspace/on-board/"
$url="https://github.com/cli/cli/releases/download/v1.11.0/gh_1.11.0_windows_amd64.zip"

# https://raw.githubusercontent.com/rajasoun/win10x-onboard/master/src/lib/core.ps1
$core_url = 'https://git.io/JZ4FD'
Write-Output 'Initializing core Functions...'
Invoke-Expression (new-object net.webclient).downloadstring($core_url)
bootstrap_env
applications_installer


