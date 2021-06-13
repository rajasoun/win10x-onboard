#Requires -Version 5 

BeforeAll { 
    # Includes system.ps1
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
}

Describe 'Windows Automation Test - Install Applications' -Tag "system"{
    It "Bootstrap Win10K System" {
        _Install_Apps
        Check-Command -cmdname 'git' | Should -Be $true
    }
}
