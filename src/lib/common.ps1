#Requires -Version 5 

function is_admin() {
    $admin = [security.principal.windowsbuiltinrole]::administrator
    $id = [security.principal.windowsidentity]::getcurrent()
    ([security.principal.windowsprincipal]($id)).isinrole($admin)
}

function Check-Command($cmdname){
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

function is_win10(){
    return [bool]([Environment]::OSVersion.Version -ge (new-object 'Version' 10,18362))
}

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