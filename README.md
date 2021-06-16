# win10x-onboard

## Windos Setup 

### HyperV, WSL, WSL2 Kernel Update, Docker, Applications and Workspace setup
1. Open Powershell and Run following commands for application installation and workspace setup
    ```
    iwr -useb https://git.io/JZBfh | iex 
    ```
1. Open Powershell as Administrator and Run following commands to setup HyperV, WSL, WSL2 Kernel Update,Docker

    ```
    iwr -useb https://git.io/JZBfh | iex 
    ```
    > FYI: System will restart two times. ReRun the Script 
1. `Invoke-Pester e2e.Tests.ps1 -Output Detailed` to Validate sucessfull setup
## TDD with Pester - Development

```
git clone https://github.com/rajasoun/win10x-onboard
cd win10x-onboard
Get-InstalledModule -Name 'Pester' -MinimumVersion 5.0

Invoke-Pester src\lib\Workspace.Tests.ps1 -Output Detailed
Invoke-Pester src\lib\Apps.Installer.Tests.ps1 -Output Detailed
Invoke-Pester src\lib\HyperV.Tests.ps1 -Output Detailed
Invoke-Pester src\lib\Wsl.Tests.ps1 -Output Detailed
Invoke-Pester src\lib\Docker.Tests.ps1 -Output Detailed
Invoke-Pester e2e.Tests.ps1 -Output Detailed
```


## TDD with Pester - Inside Docker 

1. `make -f pester-runner/Makefile  build` to build the pester-runner container
1. `make -f pester-runner/Makefile  run` to run the pester-runner container
1. `make -f pester-runner/Makefile  shell` to shell to the container
1. `make -f pester-runner/Makefile` to get help
