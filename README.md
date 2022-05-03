# win10x-onboard

## Prerequisites

Open **Powershell** as current user

1. Check Windows 10 and Above 
    ```sh
    Get-ComputerInfo | select WindowsProductName, WindowsVersion
    ```
1. Check Virtualization firmware Enabled.
    ```sh
    Get-ComputerInfo -property "HyperV*"
    ```
    The line HyperVRequirementVirtualizationFirmwareEnabled    : True if appears confirms virtualization is enabled in BIOS (firmware)
1. If not, emable virtualization in BIOS mode. [Follow the Guide](https://www.geeksforgeeks.org/how-to-enable-virtualization-vt-x-in-windows-10-bios/)

## Setup 

### Applications and Workspace setup

1. Open Powershell and Run following commands for application installation and workspace setup

    ```sh
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope currentuser
    iwr -useb https://raw.githubusercontent.com/rajasoun/win10x-onboard/main/e2e.ps1 | iex 
    cd ~\workspace
    git clone https://github.com/rajasoun/win10x-onboard
    cd win10x-onboard
    ```

### HyperV, WSL, WSL2 Kernel Update setup

1. Open Powershell as **Administrator** and Run following commands to setup HyperV, WSL, WSL2 Kernel Update,Docker

    ```sh
    Start-Process powershell -Verb runas
    cd ~\workspace\win10x-onboard
    git pull --rebase
    .\e2e.ps1 -type hyperv
    .\e2e.ps1 -type wsl
    ```
    > FYI: System will restart two times. ReRun the Script 

### Docker Desktop Setup

1. Install [Docker Desktop For Windows](https://docs.docker.com/desktop/windows/install/)


### Test Docker

1. Open Git Bash command prompt
    ```sh
    docker run --rm hello-world
    ```
    You shoulfd see Hello from Docker

1. Check the Speed of the Internet  - Run in the same **Git Bash Shell**
    ```sh
    wget -O- -q https://raw.githubusercontent.com/rajasoun/common-lib/main/docker/speed.sh | bash 
    ```


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
Invoke-Pester e2e.Tests.ps1 -Tag "apps"   -Output Detailed
Invoke-Pester e2e.Tests.ps1 -Tag "hyperv" -Output Detailed
Invoke-Pester e2e.Tests.ps1 -Tag "wsl2"   -Output Detailed
```