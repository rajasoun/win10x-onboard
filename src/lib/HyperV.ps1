#Requires -Version 5 -RunAsAdministrator

IF (-not([string]::IsNullOrWhitespace($PSScriptRoot))){
    . "$psscriptroot/log.ps1"
    . "$psscriptroot/common.ps1"
}

# Check Hyper-V
Function Check-HyperV-Enabled() {
    info "Checking if HyperV is enabled."
    $hypstate = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V
    if ($hypstate.State -eq "Enabled") {
        success "HyperV is enabled"
        return $true
    }else{
        warn "HyperV is not enabled"
        return $false
    }
}

Function Enable-HyperV() {
    info "Enabling Hyper-V..."
    #& cmd /c 'dism.exe /online /enable-feature /featurename:Microsoft-Hyper-V /all /norestart'
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All 
    Enable-WindowsOptionalFeature -Online -FeatureName Containers -All 
    success "Hyper-V is enabled. SUCCESS !!! (Reboot & Re-Run Required)"
    Start-Sleep 30
    warn "System Reboot Required & Re-run the script to continue the installation."
}

Function Enable-HyperV-IfNotDone() {
    if(-not (Check-HyperV-Enabled)){
        Enable-HyperV
    }else{
        success "Hyper-V is Already enabled. SUCCESS !!!"  
    }
}