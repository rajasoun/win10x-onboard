#Requires -Version 5 -RunAsAdministrator

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
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
    Enable-WindowsOptionalFeature -Online -FeatureName Containers -All -NoRestart
    sucess "Hyper-V is enabled. SUCCESS !!!"
}

Function Disable-HyperV() {
    info "Disabling Hyper-V..."
    Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All -NoRestart
    Disable-WindowsOptionalFeature -Online -FeatureName Containers -All -NoRestart
    sucess "Hyper-V is Disabled"
}


Function Test-Enable-HyperV() {
    if(-not (HyperV-Enabled)){
        Enable-HyperV
    }else{
        sucess "Hyper-V is Already enabled. SUCCESS !!!"  
    }
}