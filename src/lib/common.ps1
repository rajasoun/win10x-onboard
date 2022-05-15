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

function Check-ExecutionPolicyForScoop {
    # show notification to change execution policy for scoop
    $allowedExecutionPolicy = @('Unrestricted', 'RemoteSigned', 'ByPass')
    if ((Get-ExecutionPolicy).ToString() -notin $allowedExecutionPolicy) {
        Write-Error "PowerShell requires an execution policy in [$($allowedExecutionPolicy -join ", ")] to run Scoop."
        Write-Error "Please Run :"
        Write-Error "Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -scope CurrentUser"
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

Function StopProgram-If-Running($program){
    if((Get-Process -Name $program -ErrorAction SilentlyContinue) -eq $Null) { 
        info "Program $program is Not Running !!!" 
    } else { 
        Stop-Process -Name $program -Force
        success "Program $program Stopped !!!"
    }
}

Function DeleteDir-If-Exists($dir_path){
    if ( Test-Path $dir_path ) {
	    rmdir $dir_path -Force
    }else{
	    warn "Directory $dir_path Already Removed"
    }
}