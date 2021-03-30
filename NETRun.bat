@echo off
Color 0A
cls
set VARM=5
set file=address_list.txt
@echo     ==================================================================
@echo.    %%%%%%%%%%%%%%%%%%                                                      %%%%%%
@echo     %%%%%%%%%%%%%%          This script is to help administrator        %%%%%%%%%%
@echo     %%%%%%%%%%       Sawbuck ispraude file on PC network....        %%%%%%%%%%%%%%
@echo.    %%%%%%                   W0ut NETRun v. 1.0.0               %%%%%%%%%%%%%%%%%%
@echo     ==================================================================
CHOICE /C:12 /T:10 /D:1 /M ".   Send Massage?  1 - [NO], 2 - [YES] : "
if %ERRORLEVEL%==1 (
    set MY_MSG='No'
    set VARM=0
    cls
    goto _SET_TITTLE
)
if %ERRORLEVEL%==2 (
    set VARM=1
    goto _MSG
)

:_MSG
set MY_MSG=
set /p MY_MSG=".   Enter message: "
if "%MY_MSG%" EQU "" Set MY_MSG=Big brother is watching you!
@echo chcp 1251 > "%CD%\for_NETRun\message.bat"
@echo msg * /V /time:120 '%MY_MSG%' >> "%CD%\for_NETRun\message.bat"
@echo chcp 866 >> "%CD%\for_NETRun\message.bat"
@echo del %0 >> "%CD%\for_NETRun\message.bat"
cls

:_SET_TITTLE
@echo %VARM%
@echo     ==================================================================
@echo.    %%%%%%%%%%%%%%%%%%                                                      %%%%%%
@echo     %%%%%%%%%%%%%%          This script is to help administrator        %%%%%%%%%%
@echo     %%%%%%%%%%       Sawbuck ispraude file on PC network....        %%%%%%%%%%%%%%
@echo.    %%%%%%                   W0ut NETRun v. 1.0.0               %%%%%%%%%%%%%%%%%%
@echo     ==================================================================
@echo     TARGETS FILE: %file%
@echo     MESSAGE SET : %MY_MSG%
@echo.
@echo                      +---+-------------------------+
FOR /F "usebackq tokens=* delims=" %%i in ("%file%") do (
    xcopy "%CD%\for_NETRun" "\\%%i\c$\TEMP\" /H /Y /C /R /Q /Z /F 2>nul>nul
    if %VARM%==1 (
        schtasks /create /s %%i /ru system /sc once /tn mymsg /tr "C:\TEMP\message.bat" /ST "23:30:30" 2>nul>nul
        schtasks /run /s %%i /tn mymsg 2>nul>nul
        timeout 0 >nul
        schtasks /delete /s %%i /tn mymsg /f 2>nul>nul
        timeout 0 >nul
    )    
    psexec -s -i -d \\%%i "C:\TEMP\myrun.bat" 2>nul>nul
    psexec \\%CompName% -d cmd /c RD /S /Q "C:\TEMP" 2>nul>nul
    <nul set /p strTemp=".                    |   | [%time:~,8%] %%i -- Done!"
    @echo.
)
@echo                      +---+-------------------------+