#Requires -Version 5 

IF (-not([string]::IsNullOrWhitespace($PSScriptRoot))){
    . "$psscriptroot/log.ps1"
    . "$psscriptroot/common.ps1"
} 

function get_scoop(){
    # Scoop Installation
    info "Installing scoop" 
    iwr -useb get.scoop.sh | iex 
    #Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
    success  "scoop Installation Done. Success !!!" 
}

function install_scoop(){
    $ErrorActionPreference = "Stop"
    if($env:CI_WINDOWS -eq $true){
        info "Executing with CI Server Mode. Skipping Checks"  
        if (-not(Check-Command -cmdname 'scoop')) {
            get_scoop
        }else{
            warn "scoop already installed"
        }
    }else{
        info "Executing In Desktop . Performing Checks"  
        Check-PSEnvironment
        Check-ExecutionPolicyForScoop
        Check-NonAdmin # NOTE: DO NOT scoop as Administrator in Developer Desktop
        get_scoop
    }
}

function install_applications_via_scoop(){
    info "Adding scoop extras Bucket"
    scoop bucket add extras
    scoop update
    scoop install vscode
    info "Visual Studio Code Instalation Done !!!"
    scoop install gh
    info "GitHub CLI Instalation Done !!!"
}

function install_bootstrap_applications_via_scoop(){
    scoop install Git 
    success  "Git Bash Instalation Done !!!"
    scoop install pwsh
    success  "Powershell 7 Instalation Done !!!"
    scoop install wget
    info "wget Instalation Done !!!"
}

function Install-BootstrapApps(){
    install_scoop
    install_bootstrap_applications_via_scoop
}

function Install-Apps(){
    install_applications_via_scoop
}

