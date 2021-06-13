BeforeAll { 
    # Includes system.ps1
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
}

Describe 'Windows Automation Test' {
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
        It "check Persion version is greater than 5.2"{
            $module="Pester"
            $pesterModules = Get-Module -ListAvailable -Name $module
            $pesterOk = ($pesterModules | Where-Object { $_.Version.Major -eq 5 -and $_.Version.Minor -ge 2 } | Measure-Object).Count -ge 1
            $pesterOk | Should -BeTrue
        }
    }
    Context "System Test" -Tag "system" {
        It "Enable Hyper_V" {
            _Enable_HyperV
            $hyperv = Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online
            $hyperv.State | Should -Be "Enabled"
        }
        It "Enable WSL"{
            _Enable_WSL
            $hyperv = Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online
            $hyperv.State | Should -Be "Enabled"
        }
    }
}

