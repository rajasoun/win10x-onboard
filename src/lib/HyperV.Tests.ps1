#Requires -Version 5 

BeforeAll { 
    # Includes HyperV.ps1
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
}

Describe 'Windows 10 Automation' -Tag "system" {
    Context 'HyperV Management' {
        It "Test-Enable-HyperV - Enables HyperV if Not Eabled " {
            Test-Enable-HyperV
            HyperV-Enabled | Should -Be $true
        }
    }
}