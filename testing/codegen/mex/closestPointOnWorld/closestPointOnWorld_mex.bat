@echo off
set MATLAB=C:\PROGRA~1\MATLAB\R2015a
set MATLAB_ARCH=win64
set MATLAB_BIN="C:\Program Files\MATLAB\R2015a\bin"
set ENTRYPOINT=mexFunction
set OUTDIR=.\
set LIB_NAME=closestPointOnWorld_mex
set MEX_NAME=closestPointOnWorld_mex
set MEX_EXT=.mexw64
call setEnv.bat
echo # Make settings for closestPointOnWorld > closestPointOnWorld_mex.mki
echo COMPILER=%COMPILER%>> closestPointOnWorld_mex.mki
echo COMPFLAGS=%COMPFLAGS%>> closestPointOnWorld_mex.mki
echo OPTIMFLAGS=%OPTIMFLAGS%>> closestPointOnWorld_mex.mki
echo DEBUGFLAGS=%DEBUGFLAGS%>> closestPointOnWorld_mex.mki
echo LINKER=%LINKER%>> closestPointOnWorld_mex.mki
echo LINKFLAGS=%LINKFLAGS%>> closestPointOnWorld_mex.mki
echo LINKOPTIMFLAGS=%LINKOPTIMFLAGS%>> closestPointOnWorld_mex.mki
echo LINKDEBUGFLAGS=%LINKDEBUGFLAGS%>> closestPointOnWorld_mex.mki
echo MATLAB_ARCH=%MATLAB_ARCH%>> closestPointOnWorld_mex.mki
echo BORLAND=%BORLAND%>> closestPointOnWorld_mex.mki
echo OMPFLAGS= >> closestPointOnWorld_mex.mki
echo OMPLINKFLAGS= >> closestPointOnWorld_mex.mki
echo EMC_COMPILER=msvc120>> closestPointOnWorld_mex.mki
echo EMC_CONFIG=optim>> closestPointOnWorld_mex.mki
"C:\Program Files\MATLAB\R2015a\bin\win64\gmake" -B -f closestPointOnWorld_mex.mk
