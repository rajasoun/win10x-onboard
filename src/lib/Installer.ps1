#Requires -Version 5 

function success($msg) {  write-host "     >  $msg" -f darkgreen }
function info($msg) {   write-host "     >  $msg" -f cyan }
function warn($msg) {  write-host "     >  $msg" -f yellow }

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

    scoop install Git 
    success  "Git Bash Instalation Done !!!"
    info "Adding scoop extras Bucket"
    scoop bucket add extras
    scoop update
    scoop install vscode
    success "vscode Instalation Done !!!"
    if (Environment]::OSVersion.Version -ge (new-object 'Version' 10,0){
        scoop install windows-terminal
        success "Windows Terminal Instalation Done !!!"
    }
    scoop install gh
    success "GitHub CLI Instalation Done !!!"
}
