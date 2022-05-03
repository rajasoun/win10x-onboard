#Requires -Version 5 

function Check-PSEnvironment {
    if ($PSVersionTable.PSEdition -ne "Desktop") {
        Write-Error "Wrong PowerShell Environment. Please execute in PowerShell Desktop."
    }
}

function Check-NonAdmin {
    #check for non admin priviledges 
    if (([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { 
        # Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit 
        Write-Error "Please run PowerShell with Non Admin elevated permissions."
    }
}

function Check-Admin {
    #check for admin priviledges and run as admin
    if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { 
        # Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit 
        Write-Error "Admin priviledges required. Please run PowerShell with elevated permissions."
    }
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

Function Load-Script-From-Url($url){
    Invoke-Expression (new-object net.webclient).downloadstring($url)
}