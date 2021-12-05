@echo off
SET PNAME=lfflist
SET FARDIR=..\..\!far_src
IF NOT EXIST ..\..\!far_src (
    git clone https://github.com/FarGroup/FarManager.git %FARDIR%
    pushd %FARDIR%\plugins\luamacro
    make -f makefile_gcc DIRBIT=32 
    make -f makefile_gcc DIRBIT=64 
    popd
)
IF EXIST ..\..\!far_src (
    IF EXIST luaplug.o del luaplug.o
    make DIRBIT=32 TARGET=..\%PNAME%-x32.dll SRCDIR=%FARDIR% ^
        MYLDFLAGS="-L%FARDIR%\far\Release.32.gcc -L%FARDIR%\plugins\luamacro\luasdk\32"^
        CC=gcc
    IF EXIST luaplug.o del luaplug.o
    make DIRBIT=64 TARGET=..\%PNAME%-x64.dll SRCDIR=%FARDIR% ^
        MYLDFLAGS="-L%FARDIR%\far\Release.64.gcc -L%FARDIR%\plugins\luamacro\luasdk\64"^
        CC=gcc
    IF EXIST luaplug.o del luaplug.o
)
