BeforeAll { 
    # . $PSScriptRoot/core.ps1
    # . $PSCommandPath.Replace('.Tests.ps1','.ps1')
}

Describe 'Windows Automation Test' {
    Context "System Tests" -Tag "system" {
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
 

}

