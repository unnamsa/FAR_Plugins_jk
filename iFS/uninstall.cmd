if exist "%SystemRoot%\SysWOW64" (
    "%SystemRoot%\SysWOW64\regsvr32.exe" /u "%~dp0idevice.dll"
) else (
    "%SystemRoot%\system32\regsvr32.exe" /u "%~dp0idevice.dll"
)
