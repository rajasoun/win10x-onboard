#Requires -Version 5

IF (-not([string]::IsNullOrWhitespace($PSScriptRoot))){
    . "$psscriptroot/log.ps1"
    . "$psscriptroot/common.ps1"
}

function install_module($module){
    if(!(Test-ModuleAvailable $module)) {
        info "Installing $module"
        Install-Module -Name $module -Force -SkipPublisherCheck
        Import-Module $module
        info "$module Installation Done !!!"
    } else {
        warn "$module Already Installed !!!. Skipping"
    }
}

function remove($item){
    if (Test-Path $item){
        Remove-Item $item -Force -Recurse
        info "$item Removal Done !!!"
    }
}


###### Wrapper Functions ##################

function install_modules(){
    install_module "PSReadLine" 
    install_module "Pester"
}

function Bootstrap-Env(){
    info "$dir"
    GenerateFolder $dir
    install_modules
    success "Bootstrap Done!"
}
