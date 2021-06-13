#Requires -Version 5

function success($msg) {  write-host $msg -f darkgreen }
function info($msg) {  write-host " >  $msg" -f cyan }
function warn($msg) {  write-host " >  $msg" -f yellow }

Function Test-ModuleAvailable {
    param (
        [String]$Name
    )
    info "Check $Name Available"
    Return [Boolean](Get-InstalledModule -Name $Name -ErrorAction Ignore)
}

Function GenerateFolder($path) {
    $global:foldPath = $null
    foreach($foldername in $path.split("\")) {
        $global:foldPath += ($foldername+"\")
        if (!(Test-Path $global:foldPath)){
            New-Item -ItemType Directory -Path $global:foldPath
            Write-Host "$global:foldPath Folder Created Successfully"
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

function _download($url,$dir){
    $download_zip_file = $(Split-Path -Path $url -Leaf) 
    Invoke-WebRequest -Uri $url -OutFile $dir/$download_zip_file
    info "Download $download_zip_file to $dir Done !!!"
}

function _unzip($file,$dir){
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    [System.IO.Compression.ZipFile]::ExtractToDirectory("$file",$dir)
    info "Unzip $file to $location Done !!!"
}

function _remove($item){
    if (Test-Path $item){
        Remove-Item $item -Force -Recurse
        info "$item Removal Done !!!"
    }
}

function _install_toolz($url,$dir){
    GenerateFolder $dir
    $download_zip_file = $(Split-Path -Path $url -Leaf)  
    info "Getting $download_zip_file From $url"
    _download $url $dir
    info "UnZip $download_zip_file"
    _unzip "$dir/$download_zip_file" "$dir"
    info "Remove $download_zip_file"
    _remove($download_zip_file)
}

###### Wrapper Functions ##################

function install_gh_cli(){
    $url="https://github.com/cli/cli/releases/download/v1.11.0/gh_1.11.0_windows_amd64.zip"
    $dir="/test/on-board"
    _install_toolz $url $dir
}

function _install_modules(){
    _install_module "PSReadLine" 
    _install_module "Pester"
}

function bootstrap_env(){
    info "$dir"
    GenerateFolder $dir
    _install_modules
    success "Bootstrap Done!"
}
