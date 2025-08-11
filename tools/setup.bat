:: This script will do the initial setup for your mod.
@echo off
IF NOT EXIST "settings.bat" (
    exit /b 1
)
call settings.bat
:: setup the thunderstore manifest.json
powershell -Command "((gc 'packageFiles\manifest.json') -replace 'MOD_NAME', '%MOD_NAME%') -replace 'MOD_AUTHOR', '%MOD_AUTHOR%' | Out-File -encoding ASCII 'packageFiles\manifest.json'"

::setup the project.csproj
powershell -Command "(gc 'src\MageArenaModTemplate.csproj') -replace '(<AssemblyName>|<Product>)(.*?)(</AssemblyName>|</Product>)', '$1%MOD_NAME%$3' | Out-File -encoding ASCII 'src\MageArenaModTemplate.csproj'"