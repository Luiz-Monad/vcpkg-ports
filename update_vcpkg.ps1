Push-Location $PSScriptRoot
Get-ChildItem ..\build\buildtrees\ | 
    Select-Object -expand name | ForEach-Object { 
        Copy-Item "..\thirdparty\vcpkg\ports\$_" -Destination . -Recurse -Force
}
Pop-Location
