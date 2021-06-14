#Requires -Version 5 

BeforeAll { 
    # . $PSScriptRoot/core.ps1
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
    $dir="$HOME/workspace/on-board/"
}
AfterAll { 
    _remove $dir
}

Describe 'Test core.ps1' {
  Context "PreRequisites Tests" -Tag "prerequisite" {
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
    Context "Integration Test :: Workspace Setup" -Tag "workspace" {
        It "Returns <expected> (<name>)" -ForEach @(
            @{ Name = "Pester"; Expected = 'True'}
            @{ Name = "git"; Expected = 'False'} 
        ) {
            Test-ModuleAvailable -Name $name | Should -Be $expected
        }
        It "GenerateFolder with Nested Folder" {
            $Path="/tmp/dummy"
            $aTestResult = GenerateFolder $Path  -Verbose
            (Test-Path -Path $Path) | Should -BeTrue
            _remove $Path
        }
        It "Check Folder Exists without GenerateFolder" {
            $Path="/tmp/dummy"
            (Test-Path -Path $Path) | Should -BeFalse
        }
        It "_remove Folder" {
            $Path="/tmp/dummy"
            $aTestResult = GenerateFolder $Path  -Verbose
            (Test-Path -Path $Path) | Should -BeTrue
            _remove $Path
            (Test-Path -Path $Path) | Should -BeFalse
        }  
        It "_install_modules installs Pester and PSReadLine if Not Installed" -ForEach @(
            @{ Name = "Pester"; Expected = 'True'}
            @{ Name = "PSReadLine"; Expected = 'True'} 
        ) {
            _install_modules
            Test-ModuleAvailable -Name $name | Should -Be $expected
        }
        It "_install_module installs Emojis" {
            _install_module "Emojis"
            Get-Emoji -Name cactus | Should -Be '🌵'
        }
        It "bootstrap_env to be success"{
            $dir="$HOME/workspace/on-board/"
            bootstrap_env
            (Test-Path -Path $dir) | Should -BeTrue
        }
    }
}