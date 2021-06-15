#Requires -Version 5 

IF (-not([string]::IsNullOrWhitespace($PSScriptRoot))){
    . "$psscriptroot/log.ps1"
    . "$psscriptroot/common.ps1"
} 


function install_scoop(){
    if(-not(is_admin)){
        if (-not(Check-Command -cmdname 'scoop')) {
            # NOTE: DO NOT Run this script as Administrator
    
            # Scoop Installation
            info "Installing scoop"  
            Set-Executionpolicy -scope CurrentUser -executionPolicy Bypass -Force 
            iwr -useb get.scoop.sh | iex 
            success  "scoop Installation Done. Success !!!" 
        }else{
            warn "scoop already installed"
        }
    }else{
        abort("Pls. run the Script as Non Admin")
    }
}

function install_applications(){
    scoop install Git 
    success  "Git Bash Instalation Done !!!"
    info "Adding scoop extras Bucket"
    scoop bucket add extras
    scoop update
    scoop install vscode
    scoop install gh
    if (is_win10){
        scoop install windows-terminal
        success "Windows Terminal Instalation Done !!!"
    }
}

function _Install_Apps(){
    install_scoop
    install_applications
}
