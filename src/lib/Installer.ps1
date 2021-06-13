#Requires -Version 5 

function Check-Command($cmdname){
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

function _Install_Apps(){
    # Install Apps - Run In PowerShell 
    # NOTE: DO NOT Run this script as Administrator

    # Scoop Installation
    info "Installing scoop"  
    Set-Executionpolicy -scope CurrentUser -executionPolicy Bypass -Force 
    iwr -useb get.scoop.sh | iex 
    success  "scoop buckets Initialization Done" 
    # Git Bash Installation
    scoop install Git 
    success  "Git Bash Instalation Done !!!"
    info "Adding scoop extras Bucket"
    scoop bucket add extras
    scoop update
    scoop install vscode
    success "vscode Instalation Done !!!"

}
