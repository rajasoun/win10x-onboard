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

function Teardown-Apps(){
    stop_apps
    revert_to_default_theme
    uninstall_scoop
    remove_scoop_files
}