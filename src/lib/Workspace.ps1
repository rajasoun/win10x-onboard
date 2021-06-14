#Requires -Version 5

function success($msg) {  write-host "     >  $msg" -f darkgreen }
function info($msg) {   write-host "     >  $msg" -f cyan }
function warn($msg) {  write-host "     >  $msg" -f yellow }

Function Test-ModuleAvailable {
    param (
        [String]$Name
    )
    info "Check $Name Available"
    $modules = Get-Module -ListAvailable $Name
    if ($modules -eq $null) {
        return $false
    }
    return $true
    # Return [Boolean](Get-InstalledModule -Name $Name -ErrorAction Ignore)
}

Function GenerateFolder($path) {
    $global:foldPath = $null
    foreach($foldername in $path.split("\")) {
        $global:foldPath += ($foldername+"\")
        if (!(Test-Path $global:foldPath)){
            New-Item -ItemType Directory -Path $global:foldPath
            success "$global:foldPath Folder Created Successfully"
        }
    }
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
