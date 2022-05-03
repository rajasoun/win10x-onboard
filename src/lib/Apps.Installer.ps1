#Requires -Version 5 

IF (-not([string]::IsNullOrWhitespace($PSScriptRoot))){
    . "$psscriptroot/log.ps1"
    . "$psscriptroot/common.ps1"
} 


function install_scoop(){
    $ErrorActionPreference = "Stop"
    if($env:CI_WINDOWS){
        info "Executing with CI Server Mode. Skipping Checks"  
        if (-not(Check-Command -cmdname 'scoop')) {
            # Scoop Installation
            info "Installing scoop"  
            Set-Executionpolicy -scope CurrentUser -executionPolicy Bypass -Force 
            iwr -useb get.scoop.sh | iex 
            success  "scoop Installation Done. Success !!!" 
        }else{
            warn "scoop already installed"
        }
    }else{
        info "Executing In Desktop . Performing Checks"  
        Check-PSEnvironment
        # NOTE: DO NOT scoop as Administrator in Developer Desktop
        Check-NonAdmin
    }
}

function install_applications_via_scoop(){
    scoop install Git 
    success  "Git Bash Instalation Done !!!"
    info "Adding scoop extras Bucket"
    scoop bucket add extras
    scoop update
    scoop install vscode
    info "Visual Studio Code Instalation Done !!!"
    scoop install gh
    info "GitHub CLI Instalation Done !!!"
}

function Install-Apps(){
    install_scoop
    info "scoop installation completed successfully"
    install_applications_via_scoop
    info "Applications installation via scoop completed successfully"
}
