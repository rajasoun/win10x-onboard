#Requires -Version 5 

IF (-not([string]::IsNullOrWhitespace($PSScriptRoot))){
    . "$psscriptroot/log.ps1"
    . "$psscriptroot/common.ps1"
} 

function revert_to_default_theme(){
    if ((Check-Command -cmdname 'concfg')) {
        concfg import powershell-default 
        success  "Powershell Theme reverted back to default!!!"
    }else{
        warn "concfg Already Uninstalled"
    }
}

function uninstall_scoop(){
    if ((Check-Command -cmdname 'scoop')) {
        scoop uninstall scoop 
        success  "scoop & all applications uninstallation Done!!!"
    }else{
        warn "scoop Already Uninstalled"
    }
}

function uninstall_scoop_applications(){
    $packages = Get-Content .\packages\scoop.txt
    $ErrorActionPreference= 'silentlycontinue'
    foreach ($pkg in $packages) {
        scoop uninstall $pkg
    }
}

function remove_scoop_files(){
    DeleteDir-If-Exists ~\scoop
    DeleteDir-If-Exists ~\.config
}

function stop_apps(){
    info "Force stopping Applications - If Running"
    StopProgram-If-Running bash
    StopProgram-If-Running code
    StopProgram-If-Running powersession
    StopProgram-If-Running gh
    StopProgram-If-Running wget
}

function remove_oh_my_bash(){
    DeleteDir-If-Exists ~/.oh-my-bash/
    del ~/.bashrc
    del ~/.bash_profile 
    del ~/.bash_history
}

function uninstall_vscode_extensions(){
    code --uninstall-extension ms-vscode-remote.remote-containers
    code --uninstall-extension golang.go
    info "VSCode Extensions UnInstallation Done !!!"
}

# Teardowns scoop and its apps, restores to default windows terminal theme 
# Removes oh-my-bash 
function Teardown-Apps(){
    stop_apps
    revert_to_default_theme
    uninstall_vscode_extensions
    uninstall_scoop
    remove_scoop_files
    remove_oh_my_bash
}