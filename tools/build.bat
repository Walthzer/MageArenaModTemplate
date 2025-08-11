::has to be called from the primary folder.
@echo off
IF NOT EXIST "settings.bat" (
    echo "run in primary folder!"
    exit /b 1
)
call settings.bat
:: Ensure a clean slate
del %MOD_NAME%-%MOD_VERSION%.zip
rmdir /s /q build
mkdir build
:: Build your DLL
cd src
dotnet build -c Release
cd ..
IF NOT EXIST "src\bin\Release\netstandard2.1\%MOD_NAME%.dll" (
    echo dotnet build failed!
    exit \b 1
)
:: Thunderstore files
xcopy /s /i "packageFiles\*" "build\"
:: Set MOD_VERSION
powershell -Command "(gc 'build\manifest.json') -replace 'MOD_VERSION', '%MOD_VERSION%' | Out-File -encoding ASCII 'build\manifest.json'"
:: dll
xcopy /y /i "src\bin\Release\netstandard2.1\%MOD_NAME%.dll" "build\BepInEx\plugins\%MOD_NAME%\"
:: additional data
xcopy /s /i "src\data\*" "build\BepInEx\plugins\%MOD_NAME%"

IF NOT EXIST "build\BepInEx\plugins\%MOD_NAME%\\%MOD_NAME%.dll" (
    echo Mod DLL failed to copy to build folder!
    exit \b 1
)

IF EXIST %THUNDERSTORE_LOCAL_MOD_PATH% (
    xcopy /s /i /y "build\BepInEx\plugins\%MOD_NAME%\*" %THUNDERSTORE_LOCAL_MOD_PATH%
)
cd build
winrar a -r -afzip ../%MOD_NAME%-%MOD_VERSION%.zip *.*