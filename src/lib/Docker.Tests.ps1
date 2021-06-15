#Requires -Version 5 

BeforeAll { 
    # Includes system.ps1
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
    _Install_Docker
}

Describe 'Windows Automation ' -Tag "system"{
    Context 'Docker Desktop Installation'{
        It "Check for choco Installation " {
            Check-Command -cmdname 'choco' | Should -Be $true
        }
        It "Check for Docker Installation " {
            Check-Command -cmdname 'docker' | Should -Be $true
        }
    }
}

