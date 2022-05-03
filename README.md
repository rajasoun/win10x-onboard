# win10x-onboard

## Setup 

### Applications and Workspace setup

1. Open Powershell and Run following commands for application installation and workspace setup
    ```
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
    iwr -useb https://raw.githubusercontent.com/rajasoun/win10x-onboard/main/e2e.ps1 "apps"| iex 
    ```

### HyperV, WSL, WSL2 Kernel Update setup

1. Open Powershell as **Administrator** and Run following commands to setup HyperV, WSL, WSL2 Kernel Update,Docker

    ```
    iwr -useb https://raw.githubusercontent.com/rajasoun/win10x-onboard/main/e2e.ps1 "system"| iex 
    ```
    > FYI: System will restart two times. ReRun the Script 

### Docker Desktop Setup

1. Install [Docker Desktop For Windows](https://docs.docker.com/desktop/windows/install/)


## TDD with Pester - For Developers (easy To Debug)

Clone Github Repository
```sh
git clone https://github.com/rajasoun/win10x-onboard
cd win10x-onboard
Get-InstalledModule -Name 'Pester' -MinimumVersion 5.0
```

TDD Scripts
```sh
Invoke-Pester src\lib\Workspace.Tests.ps1 -Output Detailed
Invoke-Pester src\lib\Apps.Installer.Tests.ps1 -Output Detailed
Invoke-Pester src\lib\HyperV.Tests.ps1 -Output Detailed
Invoke-Pester src\lib\Wsl.Tests.ps1 -Output Detailed
```

ATDD Scripts

```sh
Invoke-Pester e2e.Tests.ps1 -Tag "prerequisite"  -Output Detailed
Invoke-Pester e2e.Tests.ps1 -Tag "apps" -ExcludeTag "hyperv", "wsl2" -Output Detailed
Invoke-Pester e2e.Tests.ps1 -Tag "hyperv" -ExcludeTag "apps", "wsl2" -Output Detailed
Invoke-Pester e2e.Tests.ps1 -Tag "wsl2" -ExcludeTag "apps", "hyperv" -Output Detailed
```