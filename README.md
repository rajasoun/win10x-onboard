# win10x-onboard

Windows Laptop setup for Developer with Docker Desktop & Applications.
The primary purpose is to have a standard way of configuring a development environment that is simple, fast and completely automated.

## Application & Tools Summary 

Following Applications & Tools are setup/teardown from the automation script

<details>
<summary>Containerization - [Docker Desktop]</summary>

Containerization - [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- Check Windows Version for Compatibility
- Check HyperV is Enabled
- Enable Virtualization in BIOS - If Required
- Enable WSL2 & Update Kernel
</details>

<details>
<summary>Applications and Tools</summary>

1. Package Manager -[scoop](https://github.com/rajasoun/multipass-dev-box)
   - [Git Bash](https://git-scm.com/)
   - [GitHub CLI](https://cli.github.com/)
   - Code Editor (IDE) - [Visual Studio Code](https://code.visualstudio.com/)
   - [concfg](https://github.com/lukesampson/concfg)
   - [PowerSession](https://github.com/Watfaq/PowerSession)

1. Visual Studio Code [Extensions](https://code.visualstudio.com/docs/editor/extension-marketplace)
   - [ms-vscode-remote.remote-containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) - [Developing inside a Container](https://code.visualstudio.com/docs/remote/containers)
   - [golang.go](https://marketplace.visualstudio.com/items?itemName=golang.Go)

1. References:
- Docker Desktop for Windows [Troubleshooting Guide](https://docs.docker.com/desktop/windows/troubleshoot/#virtualization-must-be-enabled)

</details>

# Automation 

Automation script does following Prerequisites Checks, Setup and Tests. 
Open **Powershell** as current user.
> TIP: Search for `Powershell` in Windows Start Menu and open it.

## 1. Prerequisites Checks

<details>
<summary>1. Windows Version</summary>

Check Windows 10 and Above 

```sh
Get-ComputerInfo | select WindowsProductName, WindowsVersion
```

The output should contain one of the following
* Windoes 10 Pro
* Windows 10 Enterprise and Education Edition 
* Windows 11

HyperV is supported only in above versions of Windows by default.
HyperV allows running Virtual Machine on Windows. 

</details>

<details>
<summary>2. HyperV is Enabled</summary>

1. In Powershell Windows 

```sh
systeminfo /fo csv | ConvertFrom-Csv | select OS*, System*, Hotfix*,Hyper-V* | Format-List
```

2. Check the output

- If it says `A hypervisor has been detected. Features required for Hyper-V will not be displayed.` **This means Hyper-V is already enabled**

- Otherwise, check for `Virtualization Enabled in Firmware:`. 
    * If its `No`, [click here](#Enable-Virtualization-in-BIOS).

</details>

## 2. Setup

<details>
<summary>1. Workspace & Applications</summary>
   <p>
   <details>
   <summary>1.1 Workspace</summary>

   In Powershell window Run following commands for workspace setup

   ```sh
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope currentuser
   iwr -useb https://raw.githubusercontent.com/rajasoun/win10x-onboard/main/e2e.ps1 | iex
   cd ~\workspace
   git clone https://github.com/rajasoun/win10x-onboard
   cd win10x-onboard
   Invoke-Pester src\lib\Workspace.Tests.ps1 -Output Detailed
   ```
   </details>
   
   <details>
   <summary>1.2 Prerequisite Checks</summary>
   In Powershell window Run following commands for Prerequisite Checks

   ```sh
   Invoke-Pester e2e.Tests.ps1 -Tag "prerequisite"  -Output Detailed
   ```
   </details>
   
   <details>
   <summary>1.3 Applications Setup</summary>

   In Powershell window Run following commands for application setup

   ```sh
   Invoke-Pester src\lib\Apps.Installer.Tests.ps1 -Output Detailed
   ```
   </details>
   </p>   
</details>

<details>
<summary>2. HyperV</summary>

1. In Powershell window Run following commands following commands to setup HyperV.

Switch to Elevated Previlage 

```sh
.\e2e.ps1 elevate
```

In the New Elevated Powershell as Administrator
```sh
.\e2e.ps1 hyperv
```

> FYI: System will restart.

2. After Restarting Windows, search for `Turn Windows features on or off` in the Start Menu search bar and open it.
   ![10](https://user-images.githubusercontent.com/61367380/141923398-ee251035-8e1d-42e6-9551-5c797e2b8f73.png)

3. In the Window, lookout for `Hyper-V`, `Virtual Machine Platform` and `Windows Hypervisor Platform`. Then check the check boxes before them and click `OK`. This will also take some time and then a Restart is necessary.

</details>

<details>
<summary>3. WSL2 & Kernel Update</summary>

In Powershell window Run following commands following commands to setup WSL, WSL2 Kernel Update

Switch to Elevated Previlage 

```sh
.\e2e.ps1 elevate
```

In the New Elevated Powershell as Administrator

```sh
.\e2e.ps1 wsl
```
> FYI: System will restart.

</details>

<details>
<summary>4. Docker Desktop</summary>

Install [Docker Desktop For Windows](https://docs.docker.com/desktop/windows/install/)

</details>

<details>
<summary>5. Test Docker  Setup</summary>

1. Switch to bash shell 

```sh
.\e2e.ps1 bash-it
```

1. Docker Test: Open Git Bash command prompt and output should contain `Hello from Docker`
```sh
docker run --rm hello-world
```

1. Check the Speed of the Internet using docker
```sh
MSYS_NO_PATHCONV=1  docker run --rm rajasoun/speedtest:0.1.0 "/go/bin/speedtest-go"
```

</details>

## 3. Test

<details>
<summary>1. TDD Scripts</summary>

```sh
Invoke-Pester src\lib\Workspace.Tests.ps1 -Output Detailed
Invoke-Pester src\lib\Apps.Installer.Tests.ps1 -Output Detailed
```

Switch to Elevated Previlage 

```sh
.\e2e.ps1 elevate
```

In the New Elevated Powershell as Administrator
```sh
Invoke-Pester src\lib\HyperV.Tests.ps1 -Output Detailed
Invoke-Pester src\lib\Wsl.Tests.ps1 -Output Detailed
```

</details>

<details>
<summary>2. ATDD Scripts</summary>

```sh
Invoke-Pester e2e.Tests.ps1 -Tag "prerequisite"  -Output Detailed
Invoke-Pester e2e.Tests.ps1 -Tag "apps"   -Output Detailed
```

</details>

TDD - [Test Driven Development](https://en.wikipedia.org/wiki/Test-driven_development)

ATDD - [Acceptance Test Driven Development](https://en.wikipedia.org/wiki/Acceptance_test%E2%80%93driven_development)


## 4. Teardown 

<details>
<summary>4.1 Teardown Applications</summary>

To uninstall scoop and all applications installed via scoop

```sh
.\e2e.ps1 teardown
```

</details>

<details>
<summary>4.2 Disable HyperV</summary>

To Disable HyperV

```sh
.\e2e.ps1 elevate
Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All
```

</details>

<details>
<summary>4.3 Disable WSL</summary>

To Disable WSL

```sh
.\e2e.ps1 elevate
Disable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
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

### Credits:

1. [Manu Hali](https://github.com/Manuhali)
2. [Rohini Gorige](https://github.com/rohini-gorige)

**Last Updated by [Rohini Gorige](https://github.com/rohini-gorige)**
