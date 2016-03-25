@echo off
set MATLAB=C:\PROGRA~1\MATLAB\R2015a
set MATLAB_ARCH=win64
set MATLAB_BIN="C:\Program Files\MATLAB\R2015a\bin"
set ENTRYPOINT=mexFunction
set OUTDIR=.\
set LIB_NAME=closestPoint_mex
set MEX_NAME=closestPoint_mex
set MEX_EXT=.mexw64
call setEnv.bat
echo # Make settings for closestPoint_mex > closestPoint_mex_mex.mki
echo COMPILER=%COMPILER%>> closestPoint_mex_mex.mki
echo COMPFLAGS=%COMPFLAGS%>> closestPoint_mex_mex.mki
echo OPTIMFLAGS=%OPTIMFLAGS%>> closestPoint_mex_mex.mki
echo DEBUGFLAGS=%DEBUGFLAGS%>> closestPoint_mex_mex.mki
echo LINKER=%LINKER%>> closestPoint_mex_mex.mki
echo LINKFLAGS=%LINKFLAGS%>> closestPoint_mex_mex.mki
echo LINKOPTIMFLAGS=%LINKOPTIMFLAGS%>> closestPoint_mex_mex.mki
echo LINKDEBUGFLAGS=%LINKDEBUGFLAGS%>> closestPoint_mex_mex.mki
echo MATLAB_ARCH=%MATLAB_ARCH%>> closestPoint_mex_mex.mki
echo BORLAND=%BORLAND%>> closestPoint_mex_mex.mki
echo OMPFLAGS= >> closestPoint_mex_mex.mki
echo OMPLINKFLAGS= >> closestPoint_mex_mex.mki
echo EMC_COMPILER=msvc120>> closestPoint_mex_mex.mki
echo EMC_CONFIG=optim>> closestPoint_mex_mex.mki
"C:\Program Files\MATLAB\R2015a\bin\win64\gmake" -B -f closestPoint_mex_mex.mk
