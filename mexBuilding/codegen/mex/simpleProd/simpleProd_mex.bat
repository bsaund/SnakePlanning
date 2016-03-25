@echo off
set MATLAB=C:\PROGRA~1\MATLAB\R2015a
set MATLAB_ARCH=win64
set MATLAB_BIN="C:\Program Files\MATLAB\R2015a\bin"
set ENTRYPOINT=mexFunction
set OUTDIR=.\
set LIB_NAME=simpleProd_mex
set MEX_NAME=simpleProd_mex
set MEX_EXT=.mexw64
call setEnv.bat
echo # Make settings for simpleProd > simpleProd_mex.mki
echo COMPILER=%COMPILER%>> simpleProd_mex.mki
echo COMPFLAGS=%COMPFLAGS%>> simpleProd_mex.mki
echo OPTIMFLAGS=%OPTIMFLAGS%>> simpleProd_mex.mki
echo DEBUGFLAGS=%DEBUGFLAGS%>> simpleProd_mex.mki
echo LINKER=%LINKER%>> simpleProd_mex.mki
echo LINKFLAGS=%LINKFLAGS%>> simpleProd_mex.mki
echo LINKOPTIMFLAGS=%LINKOPTIMFLAGS%>> simpleProd_mex.mki
echo LINKDEBUGFLAGS=%LINKDEBUGFLAGS%>> simpleProd_mex.mki
echo MATLAB_ARCH=%MATLAB_ARCH%>> simpleProd_mex.mki
echo BORLAND=%BORLAND%>> simpleProd_mex.mki
echo OMPFLAGS= >> simpleProd_mex.mki
echo OMPLINKFLAGS= >> simpleProd_mex.mki
echo EMC_COMPILER=msvc120>> simpleProd_mex.mki
echo EMC_CONFIG=optim>> simpleProd_mex.mki
"C:\Program Files\MATLAB\R2015a\bin\win64\gmake" -B -f simpleProd_mex.mk
