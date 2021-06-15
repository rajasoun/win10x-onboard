#Requires -Version 5 

BeforeAll { 
    # Includes system.ps1
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
    Test-Enable-Wsl2
    Wsl2-KernalUpdate
}

Describe 'Windows Automation ' -Tag "system"{
    Context 'WSL2 & Kernel Update'{
        It "Test-Enable-HyperV - Enables HyperV if Not Eabled " {
            Wsl-Enabled | Should -Be $true
        }
    }
}

