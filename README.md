# win10x-onboard

## Prerequisites

Open **Powershell** as current user.
> TIP: Search for `Powershell` in Windows Start Menu and open it.

### Check Windows Version 

1. Check Windows 10 and Above 
    ```sh
    Get-ComputerInfo | select WindowsProductName, WindowsVersion
    ```
    The output should contain one of the following
    * Windoes 10 Pro, 
    * Windows 10 Enterprise and Education Edition 
    * Windows 11 

    HyperV is supported only in above versions of Windows by default.
    > HyperV allows running Virtual Machine on Windows and its pre-requisites to run Docker 

### Check HyperV is Enabled 

1. Type `systeminfo` and press Enter. Wait for the process to finish

1. Once the results appear, search for the `Hyper-V Requirements` section which is usually the last one.

  ![11](https://user-images.githubusercontent.com/61367380/141923469-48c99804-d491-497f-bcde-69de89f90045.jpg)

  * If it says `A hypervisor has been detected. Features required for Hyper-V will not be displayed.` **This means Hyper-V is already enabled**

  * Otherwise, check for `Virtualization Enabled in Firmware:`.
    * If its `Yes`, [click here](#Enable-Hyper-V).
    * If its `No`, [click here](#Enable-Virtualization-in-BIOS).

#### Enable Hyper-V

1. Open File Explorer on windows and Navigate to a folder.

1. Right click anywhere in a blank space inside the folder. Select `New` and then Click `Text Document`.

1. Open the file in Notepad and copy and paste the following text into it.
  ```
  pushd "%~dp0"
  dir /b %SystemRoot%\servicing\Packages\*Hyper-V*.mum >hyper-v.txt
  for /f %%i in ('findstr /i . hyper-v.txt 2^>nul') do dism /online /norestart /add-package:"%SystemRoot%\servicing\Packages\%%i"
  del hyper-v.txt
  Dism /online /enable-feature /featurename:Microsoft-Hyper-V -All /LimitAccess /ALL
  pause
  ```

1. Click `File` from the Menu bar in the top of Notepad, then click `Save as...`. In the Save as Window that appears, Change the File name to `"Hyper-V.bat"` and click save.

1. Now Double click `Hyper-V.bat` to run it. This will take some time but will install all features required for Hyper-V. A Restart might be required after it is done.

1. After Restarting Windows, search for `Turn Windows features on or off` in the Start Menu search bar and open it.
  ![10](https://user-images.githubusercontent.com/61367380/141923398-ee251035-8e1d-42e6-9551-5c797e2b8f73.png)

1. In the Window, lookout for `Hyper-V`, `Virtual Machine Platform` and `Windows Hypervisor Platform`. Then check the check boxes before them and click `OK`. This will also take some time and then a Restart is necessary.

#### Enable Virtualization in BIOS

The process of enabling virtualization can vary a lot depending on the motherboard manufacturer, but it can be summarized in a few steps:

1. Completely Shutdown you Computer and turn it on again.

1. keep pressing the key to open the BIOS (usually it is `Del`, `F1`, `F2`, `F4`, `F11`, or `F12`). This key depends on the Motherboard manufacturer. You can easily google it out.

1. Once you get into the BIOS, it may look very scary or intimidating, but don't worry, you will get it right. Mouse may not work in BIOS so you might have to use the Directional or Arrow keys and the Enter key of the Keyboard to navigate.
  * Search for the CPU configuration section, it can be called `CPU configuration`, `processor`, `Northbridge` or `Chipset` and may be under an `advanced` or `advanced mode` tab or menu.
  * Now you need to look for the virtualization option and enable it, it can have different names such as `Hyper-V`, `Vanderpool`, `SVM`, `AMD-V`, `Intel Virtualization Technology` or `VT-X`.

1. Once its enabled, save and reboot your pc.

Check [HyperV Enabled](#Check-HyperV-is-Enabled) again.

**Thats it Hyper-V is enabled**

> If this part did not help you, you can specifically go the Website of the Mother Board Manufacturer of you Computer and ask for help.

## Setup 

### Applications and Workspace setup

1. In Powershell window Run following commands for application installation and workspace setup

    ```sh
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope currentuser
    iwr -useb https://raw.githubusercontent.com/rajasoun/win10x-onboard/main/e2e.ps1 | iex 
    cd ~\workspace
    git clone https://github.com/rajasoun/win10x-onboard
    cd win10x-onboard
    ```

### HyperV Setup

1. In Powershell window Run following commands following commands to setup HyperV.

    ```sh
    Start-Process powershell -Verb runas
    cd ~\workspace\win10x-onboard
    git pull --rebase
    .\e2e.ps1 -type hyperv
    ```
    > FYI: System will restart.

### WSL2 Setup

1. In Powershell window Run following commands following commands to setup WSL, WSL2 Kernel Update

    ```sh
    Start-Process powershell -Verb runas
    .\e2e.ps1 -type wsl
    ```
    > FYI: System will restart.

### Docker Desktop Setup

1. Install [Docker Desktop For Windows](https://docs.docker.com/desktop/windows/install/)


### Test Docker

1. Open Git Bash command prompt
    ```sh
    docker run --rm hello-world
    ```
    You should see Hello from Docker

1. Check the Speed of the Internet  - Run in the same **Git Bash Shell**
    ```sh
    wget -O- -q https://raw.githubusercontent.com/rajasoun/aws-toolz/main/all-in-one/speed.sh | bash
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