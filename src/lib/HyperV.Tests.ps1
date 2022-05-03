#Requires -Version 5 

BeforeAll { 
    # Includes HyperV.ps1
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
}

Describe 'Windows 10 Automation' -Tag "system" {
    Context 'HyperV Management' {
        It "Enable-HyperV-IfNotDone - Enables HyperV if Not Eabled " {
            Enable-HyperV-IfNotDone
            Check-HyperV-Enabled | Should -Be $true
        }
    }
}