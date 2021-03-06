#Requires -Version 5 

BeforeAll { 
    # Includes system.ps1
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
    Install-BootstrapApps
    Install-Apps
}

Describe 'PreRequisites Tests' {
    Context "Version Checks" -Tag "prerequisite" {
          It "verifies that the moduleName Petser - isn't null" -ForEach @(
              @{ ModuleName = "Pester"}
          ) {
              $null = Get-Module -ListAvailable -Name $ModuleName
              $ModuleName | Should -Not -BeNullOrEmpty
          }
          It "check powershell version is greater than 5"{
              $majorVersion = $PSVersionTable.PSVersion.Major
              $versionOk = $majorVersion -ge 5
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

Describe 'Automation' -Tag "apps"{
    Context "Application Installation Checks" -Tag "installer" {
        It "Git Bash Installation " {
            Check-Command -cmdname 'git' | Should -Be $true
        }
        It "GitHub CLI Installation " {
            Check-Command -cmdname 'gh' | Should -Be $true
        }
        It "Visual Studio Code Installation " {
            Check-Command -cmdname 'code' | Should -Be $true
        }
        It "scoop Installation " {
            Check-Command -cmdname 'scoop' | Should -Be $true
        }
    }
}

