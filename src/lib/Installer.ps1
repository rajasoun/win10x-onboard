#Requires -Version 5 

function _Install_Apps(){
    # Install Apps - Run In PowerShell 
    # NOTE: DO NOT Run this script as Administrator

    # Scoop Installation
    Write-Host "Installing scoop"
    Set-Executionpolicy -scope CurrentUser -executionPolicy Bypass -Force
    iwr -useb get.scoop.sh | iex
    Write-Host "scoop Installation Done"
    scoop bucket add extras
    scoop update
    Write-Host "scoop buckets Initialization Done"
    # Git Bash Installation
    scoop install Git
    scoop install vscode
    Write-Host "Git Bash and VSCode Done"
}
