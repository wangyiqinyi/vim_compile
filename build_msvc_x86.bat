REM @ECHO OFF

REM set some useful evironment variables
REM ------------------------------------
SET CUR_DIR=%~dp0
SET VIM_SRC=%CUR_DIR%\vim
SET VIM_BIN_OUTPUT=%CUR_DIR%\bin
REM SET ZIP_DIR=%CUR_DIR%\zip

REM set library versions ...
REM ------------------------------------
set LIBPYTHON2=27
REM set LIBPYTHON3=36
REM set LIBLUASHRT=53
REM REM set LIBPERLVER=520
REM set LIBTCLSHRT=86
REM set LIBTCLLONG=8.6


REM clean up and get source code from upstream
REM ------------------------------------
IF EXIST %VIM_BIN_OUTPUT% rmdir %VIM_BIN_OUTPUT% /s
IF NOT EXIST %VIM_BIN_OUTPUT% mkdir %VIM_BIN_OUTPUT%

REM CD /D %VIM_SRC%
REM git submodule update --recursive --remote

REM begin to build ...
REM ------------------------------------
CD /D %VIM_SRC%\src

REM prepare the build environment ...
REM those evironment variables can be
REM found in file "%VIM_SRC%\src\Make_mvc.mak"
REM ------------------------------------
SET VC_VAR_DIR=E:\Microsoft Visual Studio 2017\VC\Auxiliary\Build
call "%VC_VAR_DIR%\vcvarsall.bat" x86
SET CPU=x86
SET DEBUG=no
SET FEATURES=HUGE
SET CHANNEL=yes
SET MBYTE=yes
SET CSCOPE=yes
SET SNIFF=yes
SET NETBEANS=no
SET ICONV=yes
SET GETTEXT=yes
SET WINVER=0x0500
SET OPTIMIZE=MAXSPEED
REM SET LUA=C:\Dev\Utils\lua
REM SET DYNAMIC_LUA=yes
REM SET LUA_VER=%LIBLUASHRT%
SET PYTHON=E:\Python27\
SET DYNAMIC_PYTHON=no
SET PYTHON_VER=%LIBPYTHON2%
REM SET PYTHON3=C:\Dev\Python35
REM SET DYNAMIC_PYTHON3=yes
REM SET PYTHON3_VER=%LIBPYTHON3%
REM SET PERL=C:\Dev\perl
REM SET DYNAMIC_PERL=yes
REM SET PERL_VER=%LIBPERLVER%
REM SET TCL=C:\Dev\Utils\tcl
REM SET TCL_VER=%LIBTCLSHRT%
REM SET TCL_VER_LONG=%LIBTCLLONG%
REM SET DYNAMIC_TCL=yes
REM SET XPM=xpm\x86
SET SDK_INCLUDE_DIR=C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Include\
SET MSVCVER=15.0

REM compile! (x86)
REM compile binaries for both gui and console version
REM -------------------------------------
nmake /C /S /f Make_mvc.mak clean
nmake /C /S /f Make_mvc.mak IME=yes GIME=yes GUI=yes OLE=no DIRECTX=yes
ren gvim.exe gvim_noOLE.exe

nmake /C /S /f Make_mvc.mak clean
nmake /C /S /f Make_mvc.mak IME=yes GIME=yes GUI=yes OLE=yes DIRECTX=yes

nmake /C /S /f Make_mvc.mak clean
nmake /C /S /f Make_mvc.mak IME=no GIME=no GUI=no OLE=no DIRECTX=no

REM keep up the right directory structure
REM -------------------------------------
robocopy ..\runtime\ %VIM_BIN_OUTPUT% /MIR
copy ..\vimtutor.* %VIM_BIN_OUTPUT%
copy xxd\xxd.exe %VIM_BIN_OUTPUT%
copy *.exe %VIM_BIN_OUTPUT%
copy vimtbar.dll %VIM_BIN_OUTPUT%
copy README.txt %VIM_BIN_OUTPUT%

mkdir %VIM_BIN_OUTPUT%\GVimExt
mkdir %VIM_BIN_OUTPUT%\VisVim

copy gvimext\*.dll %VIM_BIN_OUTPUT%\gvimext\
copy gvimext\*.inf %VIM_BIN_OUTPUT%\gvimext\
copy gvimext\*.reg %VIM_BIN_OUTPUT%\gvimext\
copy gvimext\README.txt %VIM_BIN_OUTPUT%\gvimext\

copy VisVim\*.txt %VIM_BIN_OUTPUT%\VisVim\
copy VisVim\*.dll %VIM_BIN_OUTPUT%\VisVim\
copy VisVim\*.bat %VIM_BIN_OUTPUT%\VisVim\

REM cleanup
REM ------------------------------------
del %VIM_BIN_OUTPUT%\vimlogo.*
del %VIM_BIN_OUTPUT%\*.png
del %VIM_BIN_OUTPUT%\vim??x??.*

REM pack it!
REM 7z command line options:
REM a -- add files to archive
REM -r -- recurse subdirectories
REM -bd -- disable progress indicator
REM -mmt[N] -- set number of cpu threads
REM -mx=9 -- Level 9 of LZMA2 compression method for 7z format
REM for more options, please check the help file shipped with 7-Zip distribution
REM ------------------------------------
REM cd %VIM_BIN_OUTPUT%
REM set 7Z_BIN=E:\7-Zip\7z.exe
REM 7Z_BIN a -mx=9 -mmt4 -r -bd %ZIP_DIR%\vim-win32.7z * 
REM clean up everything
REM in the source code directory
REM ------------------------------------
CD /D %CUR_DIR%

EXIT /B
@ECHO ON
