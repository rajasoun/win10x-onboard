BeforeAll { 
    . $PSScriptRoot/core.ps1
    . $PSCommandPath.Replace('.Tests.ps1','.ps1')
}

Describe 'Test core.ps1' {
    Context "unit tests" -Tag "unit" {
        It "Returns <expected> (<name>)" -ForEach @(
            @{ Name = "Pester"; Expected = 'True'}
            @{ Name = "PSReadLine"; Expected = 'False'} 
            @{ Name = "git"; Expected = 'False'} 
        ) {
            Test-ModuleAvailable -Name $name | Should -Be $expected
        }
    }
}