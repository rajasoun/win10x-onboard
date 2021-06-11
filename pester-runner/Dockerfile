# Builds the Pester test runner image
# escape=\
FROM mcr.microsoft.com/powershell:latest

SHELL [ "pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';" ]
RUN Find-Module 'Pester'     | Install-Module -Force

COPY run_tests.ps1 /tmp
WORKDIR /test
 
ENTRYPOINT [ "pwsh", "-c", "/tmp/run_tests.ps1"]
