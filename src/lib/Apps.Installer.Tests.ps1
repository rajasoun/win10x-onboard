#Requires -Version 5 

BeforeAll { 
    # Includes system.ps1
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
    $ErrorActionPreference = "Stop"
    Check-PSEnvironment
    Check-NonAdmin
    Install-Apps
}

Describe 'Windows Automation' -Tag "system"{
    Context 'Application Installer'{
        It "Check scoop Installation " {
            Check-Command -cmdname 'scoop' | Should -Be $true
        }
        It "Check Git Bash Installation " {
            Check-Command -cmdname 'git' | Should -Be $true
        }
        It "Check Visual Studio Code Installation " {
            Check-Command -cmdname 'code' | Should -Be $true
        }
        It "Check GitHub CLI Installation " {
            Check-Command -cmdname 'gh' | Should -Be $true
        }
    }
}
