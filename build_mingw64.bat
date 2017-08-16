@echo off
REM Run this batch file from any directory to build gvim.exe and vim.exe.
REM But first edit the paths and Python version number.

REM --- Specify Vim /src folder ---
set CUR_DIR=%~dp0
set VIMSRC=%CUR_DIR%\vim\src
REM --- Add MinGW /bin directory to PATH ---
set MINGW_PATH=E:\MinGW
call %MINGW_PATH%\set_distro_paths.bat
REM --- Also make sure that PYTHON, PYTHON_VER below are correct. ---

REM get location of this batch file
set WORKDIR=%~dp0
set LOGFILE=%WORKDIR%log.txt

echo Work directory: %WORKDIR%
echo Vim source directory: %VIMSRC%

REM change to Vim /src folder
cd /d %VIMSRC%

REM --- Build GUI version (gvim.exe) ---
echo Building gvim.exe ...
REM The following command will compile with both Python 2.7 and Python 3.3
mingw32-make.exe -f Make_ming.mak PYTHON="C:/Python27" PYTHON_VER=27 DYNAMIC_PYTHON=yes PYTHON3="C:/Python33" PYTHON3_VER=33 DYNAMIC_PYTHON3=yes FEATURES=HUGE GUI=yes gvim.exe > "%LOGFILE%"

REM --- Build console version (vim.exe) ---
echo Building vim.exe ...
REM The following command will compile with both Python 2.7 and Python 3.3
mingw32-make.exe -f Make_ming.mak PYTHON="C:/Python27" PYTHON_VER=27 DYNAMIC_PYTHON=yes PYTHON3="C:/Python33" PYTHON3_VER=33 DYNAMIC_PYTHON3=yes FEATURES=HUGE GUI=no vim.exe >> "%LOGFILE%"

echo Moving files ...
move gvim.exe "%WORKDIR%"
move vim.exe "%WORKDIR%"

echo Cleaning Vim source directory ...
REM NOTE: "mingw32-make.exe -f Make_ming.mak clean" does not finish the job
IF NOT %CD%==%VIMSRC% GOTO THEEND
IF NOT EXIST vim.h GOTO THEEND
IF EXIST pathdef.c DEL pathdef.c
IF EXIST obj\NUL      RMDIR /S /Q obj
IF EXIST obji386\NUL  RMDIR /S /Q obji386
IF EXIST gobj\NUL     RMDIR /S /Q gobj
IF EXIST gobji386\NUL RMDIR /S /Q gobji386
IF EXIST gvim.exe DEL gvim.exe
IF EXIST vim.exe  DEL vim.exe
:THEEND

pause
