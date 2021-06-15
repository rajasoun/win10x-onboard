#Requires -Version 5 

function is_admin() {
    $admin = [security.principal.windowsbuiltinrole]::administrator
    $id = [security.principal.windowsidentity]::getcurrent()
    ([security.principal.windowsprincipal]($id)).isinrole($admin)
}

function Check-Command($cmdname){
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

function is_win10(){
    return [bool]([Environment]::OSVersion.Version -ge (new-object 'Version' 10,18362))
}