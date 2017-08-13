@ECHO OFF

REM set some useful evironment variables
REM ------------------------------------
SET VIM_SRC=%~dp0
SET VIM_BIN_OUPUT=E:\Vim
REM SET ZIP_DIR=%VIM_SRC%zip

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
CD /D %VIM_SRC%

REM begin to build ...
REM ------------------------------------
CD /D %VIM_SRC%\src
IF NOT EXIST temp\win64 mkdir temp\win64

REM prepare the build environment ...
REM those evironment variables can be
REM found in file "%VIM_SRC%\src\Make_mvc.mak"
REM ------------------------------------
call "E:\Microsoft Visual Studio 2017\VC\Auxiliary\Build\vcvarsall.bat" amd64
SET CPU=AMD64
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
SET PYTHON=E:\Python27
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
REM SET XPM=xpm\x64
SET SDK_INCLUDE_DIR=C:\Program Files (x86)\Microsoft SDKs\Windows\v7.1A\Include
SET MSVCVER=15.0

REM compile! (x64)
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
robocopy ..\runtime\ temp\win64 /MIR
copy ..\vimtutor.* temp\win64
copy xxd\xxd.exe temp\win64
copy *.exe temp\win64
copy vimtbar.dll temp\win64
copy README.txt temp\win64

mkdir temp\win64\GVimExt
mkdir temp\win64\VisVim

copy gvimext\*.dll temp\win64\gvimext\
copy gvimext\*.inf temp\win64\gvimext\
copy gvimext\*.reg temp\win64\gvimext\
copy gvimext\README.txt temp\win64\gvimext\

copy VisVim\*.txt temp\win64\VisVim\
copy VisVim\*.dll temp\win64\VisVim\
copy VisVim\*.bat temp\win64\VisVim\

REM cleanup
REM ------------------------------------
del temp\win64\vimlogo.*
del temp\win64\*.png
del temp\win64\vimE:\Python27??x??.*

REM pack it!
REM 7z command line options:
REM a -- add files to archive
REM -r -- recurse subdirectories
REM -bd -- disable progress indicator
REM -mmt[N] -- set number of cpu threads
REM -mx=9 -- Level 9 of LZMA2 compression method for 7z format
REM for more options, please check the help file shipped with 7-Zip distribution
REM ------------------------------------
REM cd temp\win64
REM set 7Z_BIN=E:\7-Zip\7z.exe
REM 7Z_BIN a -mx=9 -mmt4 -r -bd %ZIP_DIR%\vim-win64.7z * 
REM clean up everything
REM in the source code directory
REM ------------------------------------
REM MOVE temp %VIM_BIN_OUPUT%
CD /D %VIM_SRC%

EXIT /B
@ECHO ON
