#Requires -Version 5 

BeforeAll { 
    # Includes system.ps1
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
    Teardown-Apps
}

Describe 'Windows Automation' -Tag "system"{
    Context 'Bootstrap Applications (scoop, git & wget) Installation Test'{
        It "Check scoop Installation " {
            Check-Command -cmdname 'scoop' | Should -Be $false
        }
        It "Check Git Bash Installation " {
            Check-Command -cmdname 'git' | Should -Be $false
        }
        It "Check wget Installation " {
            Check-Command -cmdname 'wget' | Should -Be $false
        }
    }
    Context 'Applications (vscode, gh) Installation Test'{    
        It "Check Visual Studio Code Installation " {
            Check-Command -cmdname 'code' | Should -Be $false
        }
        It "Check GitHub CLI Installation " {
            Check-Command -cmdname 'gh' | Should -Be $false
        }
    }
}
