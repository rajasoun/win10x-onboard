#Requires -Version 5

$testResults = Invoke-Pester -CodeCoverage (Get-ChildItem -Path *\*\*.ps1 -Exclude *.Tests.* ).FullName -PassThru

# $testResults.CodeCoverage.CommandsExecuted
Write-Host "Code Coverage % : " $testResults.CodeCoverage.CoveragePercent
Write-Host "Missed Functions"
Write-Host "================"
$testResults.CodeCoverage.CommandsMissed | grep Function | sort | unique
