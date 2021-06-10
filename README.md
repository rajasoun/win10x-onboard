# win10x-onboard

## Windos Setup 

### HyperV, WSL, WSL2 Kernel Update and Docker

1. Open Powershell as Administrator 
1. Run following commands to setup HyperV, WSL, WSL2 Kernel Update and Docker
    ```
    iwr -useb https://git.io/JZBfh | iex && bootstrap_env 
    iwr -useb https://git.io/JZBfh | iex && admin_hyperv_wsl_docker_bootstrap
    ```
FYI: System will restart couple of times 

### Git-Bash and Visual Studio Code

1. Open Powershell (Note - Not as Adminstrator)
1. Run the following Command to Install Git-Bash and Visual Studio Code
    ```
    iwr -useb https://git.io/JZBfh | iex &&  applications_installer
    ```

### Install Visual Stiudio Remote Container Extension 

1. Open Git Bash 
    ```
    cd "$HOME/workspace"
    code --install-extension ms-vscode-remote.remote-containers
    ```

## Progress Tracking

Done:
1. Automate HyperV, WSL, WSL2 Kernel Update & Docker Desktop - ✅
2. Automate Applications (Git Bash and VC Code) -  ✅ (Checks Pending)

Learn:
1. Dont keep ps1 scripts in Downloads 

To Do:
1. Condition Check for Installer and Uninstaller 
2. Log details to File 
3. Git Config 
4. SSH Token 