#Requires -Version 5

IF (-not([string]::IsNullOrWhitespace($PSScriptRoot))){
    . "$psscriptroot/log.ps1"
    . "$psscriptroot/common.ps1"
}

function _install_module($module){
    if(!(Test-ModuleAvailable $module)) {
        info "Installing $module"
        Install-Module -Name $module -Force -SkipPublisherCheck
        Import-Module $module
        info "$module Installation Done !!!"
    } else {
        warn "$module Already Installed !!!. Skipping"
    }
}

function _remove($item){
    if (Test-Path $item){
        Remove-Item $item -Force -Recurse
        info "$item Removal Done !!!"
    }
}


###### Wrapper Functions ##################

function _install_modules(){
    _install_module "PSReadLine" 
    _install_module "Pester"
}

function _Bootstrap_Env(){
    info "$dir"
    GenerateFolder $dir
    _install_modules
    success "Bootstrap Done!"
}
