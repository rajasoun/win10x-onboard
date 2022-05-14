#Requires -Version 5 

IF (-not([string]::IsNullOrWhitespace($PSScriptRoot))){
    . "$psscriptroot/log.ps1"
    . "$psscriptroot/common.ps1"
} 

function revert_to_default_theme(){
    concfg import powershell-defauly -y
    success  "Powershell Theme reverted back to default!!!"
}

function uninstall_scoop(){
    scoop uninstall scoop
}

function remove_scoop_files(){
    rmdir ~/scoop
    rmdir ~/.config
}

function Teardown-Apps(){
    revert_to_default_theme
    uninstall_scoop
    remove_scoop_files
}