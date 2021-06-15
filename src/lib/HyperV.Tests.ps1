#Requires -Version 5 

BeforeAll { 
    # Includes HyperV.ps1
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
}

AfterAll { 
    Disable-HyperV
}

Describe 'Windows 10 Automation' -Tag "system" {
    Context 'HyperV Management' {
        It "Test-Enable-HyperV - Enables HyperV " {
            Test-Enable-HyperV
            HyperV-Enabled | Should -Be $true
        }
        It "Test-Enable-HyperV - Disable HyperV " {
            Disable-HyperV
            HyperV-Enabled | Should -Be $false
        }
    }
}