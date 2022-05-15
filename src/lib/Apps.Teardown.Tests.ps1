#Requires -Version 5 

BeforeAll { 
    # Includes system.ps1
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
    Teardown-Apps
}

Describe 'Windows Automation' -Tag "system"{
    Context 'Bootstrap Applications (scoop, git & wget) UnInstallation Test'{
        It "Check scoop UnInstallation " {
            Check-Command -cmdname 'scoop' | Should -Be $false
        }
        It "Check Git Bash UnInstallation " {
            Check-Command -cmdname 'git' | Should -Be $false
        }
    }

    Context 'Applications (vscode, gh,concfg) UnInstallation Test'{    
        It "Check Visual Studio Code UnInstallation " {
            Check-Command -cmdname 'code' | Should -Be $false
        }
        It "Check GitHub CLI UnInstallation " {
            Check-Command -cmdname 'gh' | Should -Be $false
        }
        It "concfg UnInstallation " {
            Check-Command -cmdname 'gh' | Should -Be $false
        }
        It "PowerSession Installation " {
            Check-Command -cmdname 'PowerSession' | Should -Be $true
        }
    }
}
