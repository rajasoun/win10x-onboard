#Requires -Version 5

$testResults = Invoke-Pester -CodeCoverage (Get-ChildItem -Path *\*\*.ps1 -Exclude *.Tests.* ).FullName -PassThru

# $testResults.CodeCoverage.CommandsExecuted
Write-Host "Missed Functionsc"
$testResults.CodeCoverage.CommandsMissed | grep Function | sort | unique
