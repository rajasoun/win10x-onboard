#Requires -Version 5 -RunAsAdministrator

Function Bootstrap_HyperV {
    Write-Host "Checking if Hyper-V is enabled."
    $hyperv = Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online
    if($hyperv.State -eq "Enabled") {
        Write-Host "Hyper-V is enabled. SUCCESS !!!"
    } else {
        Write-Host "Hyper-V is Disabled."
        Write-Host "Enabling Hyper-V feature now"
        Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
        Start-Sleep 30
        Write-Host "Hyper-V is enabled now reboot the system and re-run the script to continue the installation."
    }
}