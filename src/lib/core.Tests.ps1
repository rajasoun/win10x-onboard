BeforeAll { 
    . $PSScriptRoot/core.ps1
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
}

Describe 'Test core.ps1' {
    Context "System tests" -Tag "system" {
        It "Returns <expected> (<name>)" -ForEach @(
            @{ Name = "Pester"; Expected = 'True'}
            @{ Name = "git"; Expected = 'False'} 
        ) {
            Test-ModuleAvailable -Name $name | Should -Be $expected
        }
    }
    Context "Integration tests" -Tag "integration" {
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
        It "install_gh_cli downloads gh.exe" {
            $Path="on-board/bin/gh.exe"
            $aTestResult = install_gh_cli 
            (Test-Path -Path $Path) | Should -BeTrue
            _remove "on-board"
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
        It "Bootstrap_HyperV to be success"{
            Bootstrap_HyperV
            $hyperv = Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online
            $hyperv.State | Should -Be 'Enabled'
        }
    }
}