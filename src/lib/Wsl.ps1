#Requires -Version 5 -RunAsAdministrator

IF (-not([string]::IsNullOrWhitespace($PSScriptRoot))){
    . "$psscriptroot/log.ps1"
    . "$psscriptroot/common.ps1"
}

# Check WSL
Function Check-Wsl-Enabled() {
    info "Checking if Wsl is enabled."
    $wsl = Get-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -Online
    if ($wsl.State -eq "Enabled") {
        success "WSL is enabled"
        return $true
    }else{
        warn "WSL is not enabled"
        return $false
    }
}

Function Enable-Wsl() {
    info "Enabling Wsl..."
    & cmd /c 'dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart'
    & cmd /c 'dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart'
    Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform 
    success "WSL is enabled. SUCCESS !!! (Rebbot & Re-Run the Script)"
    Start-Sleep 30
    warn "System Reboot Required & Re-run the script to continue the installation."
}

Function Enable-Wsl-IfNotDone() {
    if(-not (Check-Wsl-Enabled)){
        Enable-Wsl   
    }else{
        success "WSL is Already enabled. SUCCESS !!!"  
    }
}

Function Wsl2-KernalUpdate {
    info "Upgrade WSL Linux Kernel"
    if ([Environment]::Is64BitOperatingSystem){
        warn "System is x64. Need to update Linux kernel..."
        if (-not (Test-Path wsl_update_x64.msi)){
            info "Downloading Linux kernel update package..."
            $URL='https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi'
            $destination='wsl_update_x64.msi'
            $progressPreference = 'silentlyContinue'
            Invoke-WebRequest -Uri $URL -OutFile $destination -ErrorAction Stop
            $progressPreference = 'Continue'
        }
        info "Installing Linux kernel update package..."
        Start-Process msiexec.exe -Wait -ArgumentList '/I wsl_update_x64.msi /quiet'
        success "Linux kernel update package installed."
    }
    info "WSL is enabled. Setting it to WSL2"
    wsl --set-default-version 2
    success "WSL2 is enabled with Linux Kernal Upgrade. SUCCESS !!!"
}