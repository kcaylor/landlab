@echo off
:: To build extensions for 64 bit Python 3, we need to configure environment
:: variables to use the MSVC 2010 C++ compilers from GRMSDKX_EN_DVD.iso of:
:: MS Windows SDK for Windows 7 and .NET Framework 4
::
:: More details at:
:: https://github.com/cython/cython/wiki/64BitCythonExtensionsOnWindows
::
IF "%DISTUTILS_USE_SDK%"=="1" (
    SET WIN_SDK_ROOT=C:\Program Files\Microsoft SDKs\Windows
    SET MAJOR_PYTHON_VERSION="%PYTHON_VERSION:~0,1%"
    IF %MAJOR_PYTHON_VERSION% == "2" (
        SET WINDOWS_SDK_VERSION="v7.0"
    ) ELSE IF %MAJOR_PYTHON_VERSION% == "3" (
        SET WINDOWS_SDK_VERSION="v7.1"
    ) ELSE (
        ECHO Unsupported Python version: "%MAJOR_PYTHON_VERSION%"
        EXIT 1
    )

    IF "%PLATFORM%"=="x64" (
        ECHO Configuring Windows SDK %WINDOWS_SDK_VERSION% for Python %MAJOR_PYTHON_VERSION% on a 64 bit architecture
        SET MSSdk=1
        "%WIN_SDK_ROOT%\%WINDOWS_SDK_VERSION%\Setup\WindowsSdkVer.exe" -q -version:%WINDOWS_SDK_VERSION%
        "%WIN_SDK_ROOT%\%WINDOWS_SDK_VERSION%\Bin\SetEnv.cmd" /x64 /release
    ) ELSE (
        ECHO Using default MSVC build environment for 32 bit architecture
    )
) ELSE (
    ECHO Using default MSVC build environment
)

ECHO Executing: %*
CALL %* || EXIT 1
