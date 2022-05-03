#Requires -Version 5 

BeforeAll { 
    # Includes system.ps1
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
    Enable-Wsl-IfNotDone
    Wsl2-KernalUpdate
}

Describe 'Windows Automation ' -Tag "system"{
    Context 'WSL2 Enabled & Upgraded'{
        It "WSL2 To be Enabled " {
            Check-Wsl-Enabled | Should -Be $true
        }
    }
}

