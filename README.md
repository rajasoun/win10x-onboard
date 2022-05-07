# win10x-onboard

Windows Laptop setup for Developer with Docker Desktop & Applications.
The primary purpose is to have a standard way of configuring a development environment that is simple, fast and completely automated.

Onboard Automation script configures and installs the following.

1. Containerization - [Docker Desktop](https://www.docker.com/products/docker-desktop/)
   - Check Windows Version for Compatibility
   - Check HyperV is Enabled
   - Enable Virtualization in BIOS - If Required
   - Enable WSL2 & Update Kernel
1. Package Manager -[scoop](https://github.com/rajasoun/multipass-dev-box)
   - [Git Bash](https://git-scm.com/)
   - [GitHub CLI](https://cli.github.com/)
   - Code Editor (IDE) - [Visual Studio Code](https://code.visualstudio.com/)
1. Visual Studio Code [Extensions](https://code.visualstudio.com/docs/editor/extension-marketplace)
   - [ms-vscode-remote.remote-containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) - [Developing inside a Container](https://code.visualstudio.com/docs/remote/containers)
   - [golang.go](https://marketplace.visualstudio.com/items?itemName=golang.Go)

Refernces:

- Docker Desktop for Windows [Troubleshooting Guide](https://docs.docker.com/desktop/windows/troubleshoot/#virtualization-must-be-enabled)

## Prerequisites

Open **Powershell** as current user.

> TIP: Search for `Powershell` in Windows Start Menu and open it.

### Checks

<details>
  <summary>1. Windows Version</summary>

1. Check Windows 10 and Above 

```sh
Get-ComputerInfo | select WindowsProductName, WindowsVersion
```

The output should contain one of the following
* Windoes 10 Pro
* Windows 10 Enterprise and Education Edition 
* Windows 11

HyperV is supported only in above versions of Windows by default.HyperV allows running Virtual Machine on Windows. 

</details>

<details>
  <summary>2. HyperV is Enabled</summary>

1. Type `systeminfo` and press Enter. Wait for the process to finish

1. Once the results appear, search for the `Hyper-V Requirements` section which is usually the last one.

![11](https://user-images.githubusercontent.com/61367380/141923469-48c99804-d491-497f-bcde-69de89f90045.jpg)

- If it says `A hypervisor has been detected. Features required for Hyper-V will not be displayed.` **This means Hyper-V is already enabled**

- Otherwise, check for `Virtualization Enabled in Firmware:`. \* If its `No`, [click here](#Enable-Virtualization-in-BIOS).
</details>

## Setup

<details>
  <summary>1. Workspace & Applications</summary>

In Powershell window Run following commands for application installation and workspace setup

```sh
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope currentuser
iwr -useb https://raw.githubusercontent.com/rajasoun/win10x-onboard/main/e2e.ps1 | iex
cd ~\workspace
git clone https://github.com/rajasoun/win10x-onboard
cd win10x-onboard
```

</details>

<details>
  <summary>2. HyperV</summary>

1. In Powershell window Run following commands following commands to setup HyperV.

```sh
Start-Process powershell -Verb runas
cd ~\workspace\win10x-onboard
git pull --rebase
.\e2e.ps1 -type hyperv
```

> FYI: System will restart.

1. After Restarting Windows, search for `Turn Windows features on or off` in the Start Menu search bar and open it.
   ![10](https://user-images.githubusercontent.com/61367380/141923398-ee251035-8e1d-42e6-9551-5c797e2b8f73.png)

1. In the Window, lookout for `Hyper-V`, `Virtual Machine Platform` and `Windows Hypervisor Platform`. Then check the check boxes before them and click `OK`. This will also take some time and then a Restart is necessary.

Check [HyperV Enabled](#Check-HyperV-is-Enabled) again.

</details>

<details>
  <summary>3. WSL2 & Kernel Update</summary>

In Powershell window Run following commands following commands to setup WSL, WSL2 Kernel Update

```sh
Start-Process powershell -Verb runas
.\e2e.ps1 -type wsl
```
> FYI: System will restart.

</details>

<details>
  <summary>4. Docker Desktop</summary>
Install [Docker Desktop For Windows](https://docs.docker.com/desktop/windows/install/)
</details>

<details>
  <summary>5. Test Setup</summary>

1. Open Git Bash command prompt

```sh
docker run --rm hello-world
```

   You should see Hello from Docker

1. Check the Speed of the Internet - Run in the same **Git Bash Shell**

   ```sh
   wget -O- -q https://raw.githubusercontent.com/rajasoun/aws-toolz/main/all-in-one/speed.sh | bash
   ```
</details>

## TDD with Pester - For Developers (easy To Debug)

<details>
  <summary>1. Clone Github Repository</summary>

```sh
git clone https://github.com/rajasoun/win10x-onboard
cd win10x-onboard
Get-InstalledModule -Name 'Pester' -MinimumVersion 5.0
```

</details>

<details>
  <summary>2. TDD Scripts</summary>

```sh
Invoke-Pester src\lib\Workspace.Tests.ps1 -Output Detailed
Invoke-Pester src\lib\Apps.Installer.Tests.ps1 -Output Detailed
Invoke-Pester src\lib\HyperV.Tests.ps1 -Output Detailed
Invoke-Pester src\lib\Wsl.Tests.ps1 -Output Detailed
```

</details>

<details>
  <summary>3. ATDD Scripts</summary>

```sh
Invoke-Pester e2e.Tests.ps1 -Tag "prerequisite"  -Output Detailed
Invoke-Pester e2e.Tests.ps1 -Tag "apps"   -Output Detailed
Invoke-Pester e2e.Tests.ps1 -Tag "hyperv" -Output Detailed
Invoke-Pester e2e.Tests.ps1 -Tag "wsl2"   -Output Detailed
```

</details>

## Enable Virtualization in BIOS

<details>
  <summary>Manual Steps</summary>
The process of enabling virtualization can vary a lot depending on the motherboard manufacturer, but it can be summarized in a few steps:

1. Completely Shutdown you Computer and turn it on again.

1. Keep pressing the key to open the BIOS (usually it is `Del`, `F1`, `F2`, `F4`, `F11`, or `F12`). This key depends on the Motherboard manufacturer. You can easily google it out.

1. Once you get into the BIOS, it may look very scary or intimidating, but don't worry, you will get it right. Mouse may not work in BIOS so you might have to use the Directional or Arrow keys and the Enter key of the Keyboard to navigate.

- Search for the CPU configuration section, it can be called `CPU configuration`, `processor`, `Northbridge` or `Chipset` and may be under an `advanced` or `advanced mode` tab or menu.
- Now you need to look for the virtualization option and enable it, it can have different names such as `Hyper-V`, `Vanderpool`, `SVM`, `AMD-V`, `Intel Virtualization Technology` or `VT-X`.
- Once its enabled, save and reboot your pc.

> If this part did not help you, you can specifically go the Website of the Mother Board Manufacturer of you Computer and ask for help.

</details>

Credits:

1. [Manu Hali](https://github.com/Manuhali)
