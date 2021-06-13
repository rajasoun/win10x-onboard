#Requires -Version 5 -RunAsAdministrator

BeforeAll { 
    # Includes system.ps1
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
}

Describe 'Windows Automation Test' -Tag "system"{
    Context "System Test - Enable Hyper-V "  {
        It "Enable HyperV" {
            $result = _Enable_HyperV
            $result | Should -Be $true
        }
        It "Check HyperV is Enabled "{
            $hyperv = Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online
            $hyperv | Should Not -Be $null
            $hyperv.State | Should -Be 'Enabled'
        }
    }
    Context "System Test - Enable WSL "  {
        It "_Enable_WSL" {
            $result = _Enable_WSL
            $result | Should -Be $true
        }
        It "Check _Enable_WSL is Enabled "{
            $wsl = Get-WindowsOptionalFeature -FeatureName Microsoft-Windows-Subsystem-Linux -Online
            $wsl | Should Not -Be $null
            $wsl.State | Should -Be 'Enabled'
        }
    }
    Context "System Test - _WSL2_KernalUpdate "  {
        It "_WSL2_KernalUpdate" {
            $result = _WSL2_KernalUpdate
            $result | Should -Be $true
        }
    }
    Context "System Test - _Install_Docker "  {
        It "_Install_Docker" {
            $result = _Install_Docker
            $result | Should -Be $true
        }
    }  
}

Describe 'Windows Automation Test - Bootstrap' -Tag "system"{
    It "Bootstrap Win10K System" {
        $result = _Bootstrap
        $result | Should -Be $true
    }
}


