# Builds the Pester test runner image
# escape=\
FROM mcr.microsoft.com/powershell:latest

SHELL [ "pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';" ]
RUN Find-Module 'Pester' | Install-Module -Force

WORKDIR /test

ENTRYPOINT [ "pwsh", "-c", "Invoke-Pester"]