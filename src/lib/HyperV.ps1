#Requires -Version 5 -RunAsAdministrator

. "$psscriptroot/log.ps1"

# Check Hyper-V
Function HyperV-Enabled() {
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
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All 
    Enable-WindowsOptionalFeature -Online -FeatureName Containers -All 
    success "Hyper-V is enabled. SUCCESS !!!"
    Start-Sleep 30
    warn "System Reboot Required"
}

Function Test-Enable-HyperV() {
    if(-not (HyperV-Enabled)){
        Enable-HyperV
    }else{
        success "Hyper-V is Already enabled. SUCCESS !!!"  
    }
}