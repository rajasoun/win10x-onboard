#Requires -Version 5 

BeforeAll { 
    # Includes system.ps1
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
    _Install_Apps
}

AfterAll { 
    if ($env:CI_WINDOWS -eq $false) {
        scoop uninstall scoop
    }
}

Describe 'Windows Automation - Application Installer' -Tag "system"{
    It "GitHub CLI Installation " {
        Check-Command -cmdname 'gh' | Should -Be $true
    }
    It "Git Bash Installation " {
        Check-Command -cmdname 'git' | Should -Be $true
    }
    It "Visual Studio Code Installation " {
        Check-Command -cmdname 'code' | Should -Be $true
    }
    It "Windows Terminal Installation " {
        Check-Command -cmdname 'windowsterminal' | Should -Be $true
    }
}
