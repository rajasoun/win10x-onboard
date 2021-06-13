#Requires -Version 5

Write-Host "Running Tests" 
function code_coverage_report(){
    #$testResults.CodeCoverage.CommandsExecuted
    Write-Host "Code Coverage % : " $testResults.CodeCoverage.CoveragePercent
    Write-Host "Missed Functions"
    Write-Host "================"
    $testResults.CodeCoverage.CommandsMissed | grep Function | sort | unique
}
Switch($args[0]){
    "system" {
        $testResults = Invoke-Pester -CodeCoverage (Get-ChildItem -Path *\*\*.ps1 ).FullName -PassThru
        code_coverage_report
    }
    "workspace" {
        $testResults = Invoke-Pester -ExcludeTag "system" -CodeCoverage (Get-ChildItem -Path *\*\Workspace.ps1 ).FullName -PassThru 
        code_coverage_report
    }
    default{
        Invoke-Pester -Output Detailed -ExcludeTag "system"

    }
}


