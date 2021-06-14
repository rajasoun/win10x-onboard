#Requires -Version 5 

Describe 'PreRequisites Tests' {
    Context "Version Checks" -Tag "prerequisite" {
          It "verifies that the moduleName Petser - isn't null" -ForEach @(
              @{ ModuleName = "Pester"}
          ) {
              $null = Get-Module -ListAvailable -Name $ModuleName
              $ModuleName | Should -Not -BeNullOrEmpty
          }
          It "check powershell version is greater than 7"{
              $majorVersion = $PSVersionTable.PSVersion.Major
              $versionOk = $majorVersion -ge 7
              $versionOk | Should -BeTrue
          }
          It "check Pester version is greater than 5.2"{
              $module="Pester"
              $pesterModules = Get-Module -ListAvailable -Name $module
              $pesterOk = ($pesterModules | Where-Object { $_.Version.Major -eq 5 -and $_.Version.Minor -ge 2 } | Measure-Object).Count -ge 1
              $pesterOk | Should -BeTrue
          }
    }
}

Describe 'Windows Automation' -Tag "system"{
    Context "Application Installation Checks" -Tag "prerequisite" {
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
}

