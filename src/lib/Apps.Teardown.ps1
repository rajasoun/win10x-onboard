#Requires -Version 5 

IF (-not([string]::IsNullOrWhitespace($PSScriptRoot))){
    . "$psscriptroot/log.ps1"
    . "$psscriptroot/common.ps1"
} 

function uninstall_scoop(){
    scoop uninstall scoop
}

function remove_scoop_files(){
    rmdir ~/scoop
    rmdir ~/.config
}

function Teardown-Apps(){
    uninstall_scoop
    remove_scoop_files
}