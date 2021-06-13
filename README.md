# win10x-onboard

## Windos Setup 

### HyperV, WSL, WSL2 Kernel Update and Docker

1. Open Powershell as Administrator 
1. Run following commands to setup HyperV, WSL, WSL2 Kernel Update and Docker
    ```
    iwr -useb https://git.io/JZBfh | iex 
    ```
FYI: System will restart couple of times 

### Git-Bash and Visual Studio Code

1. Open Powershell (Note - Not as Adminstrator)
1. Run the following Command to Install Git-Bash and Visual Studio Code
    ```
    iwr -useb https://git.io/JZFjq | iex 
    ```

### Install Visual Stiudio Remote Container Extension 

1. Open Git Bash 
    ```
    cd "$HOME/workspace"
    code --install-extension ms-vscode-remote.remote-containers
    ```

## TDD with Pester

1. `make -f pester-runner/Makefile  build` to build the pester-runner container
1. `make -f pester-runner/Makefile  run` to run the pester-runner container
1. `make -f pester-runner/Makefile  shell` to shell to the container
1. `make -f pester-runner/Makefile` to get help