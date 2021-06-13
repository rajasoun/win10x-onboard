#Requires -Version 5

Write-Host "Running Tests" 
Switch($args[0]){
    "system"  
        {
            $testResults = Invoke-Pester -CodeCoverage (Get-ChildItem -Path *\*\*.ps1 ).FullName -PassThru
        }
    default
        {
            $testResults = Invoke-Pester -ExcludeTag "system" -CodeCoverage (Get-ChildItem -Path *\*\Workspace.ps1 ).FullName -PassThru
        }
}


# $testResults.CodeCoverage.CommandsExecuted
Write-Host "Code Coverage % : " $testResults.CodeCoverage.CoveragePercent
Write-Host "Missed Functions"
Write-Host "================"
$testResults.CodeCoverage.CommandsMissed | grep Function | sort | unique
