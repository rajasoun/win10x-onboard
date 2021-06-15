#Requires -Version 5 -RunAsAdministrator

# Check WSL
Function Wsl-Enabled() {
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
    Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart
    sucess "Wsl is enabled. SUCCESS !!!"
}

Function Disable-Wsl() {
    info "Enabling Wsl..."
    & cmd /c 'dism.exe /online /disable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart'
    & cmd /c 'dism.exe /online /disable-feature /featurename:VirtualMachinePlatform /all /norestart'
    Disable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart
    sucess "Wsl is Disabled."
}

Function _WSL2_KernalUpdate {
    Write-Host "Upgrade WSL Linux Kernel"
    if ([Environment]::Is64BitOperatingSystem){
        Write-Host "System is x64. Need to update Linux kernel..."
        if (-not (Test-Path wsl_update_x64.msi)){
            Write-Host "Downloading Linux kernel update package..."
            $URL='https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi'
            $destination='wsl_update_x64.msi'
            $progressPreference = 'silentlyContinue'
            Invoke-WebRequest -Uri $URL -OutFile $destination -ErrorAction Stop
            $progressPreference = 'Continue'
        }
        Write-Host "Installing Linux kernel update package..."
        Start-Process msiexec.exe -Wait -ArgumentList '/I wsl_update_x64.msi /quiet'
        Write-Host "Linux kernel update package installed."
    }
    Write-Host "WSL is enabled. Setting it to WSL2"
    wsl --set-default-version 2
    Write-Host "WSL2 is enabled with Linux Kernal Upgrade. SUCCESS !!!"
}