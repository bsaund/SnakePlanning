MATLAB="/usr/local/MATLAB/R2015a"
Arch=glnxa64
ENTRYPOINT=mexFunction
MAPFILE=$ENTRYPOINT'.map'
PREFDIR="/home/bsaund/.matlab/R2015a"
OPTSFILE_NAME="./setEnv.sh"
. $OPTSFILE_NAME
COMPILER=$CC
. $OPTSFILE_NAME
echo "# Make settings for dummy" > dummy_mex.mki
echo "CC=$CC" >> dummy_mex.mki
echo "CFLAGS=$CFLAGS" >> dummy_mex.mki
echo "CLIBS=$CLIBS" >> dummy_mex.mki
echo "COPTIMFLAGS=$COPTIMFLAGS" >> dummy_mex.mki
echo "CDEBUGFLAGS=$CDEBUGFLAGS" >> dummy_mex.mki
echo "CXX=$CXX" >> dummy_mex.mki
echo "CXXFLAGS=$CXXFLAGS" >> dummy_mex.mki
echo "CXXLIBS=$CXXLIBS" >> dummy_mex.mki
echo "CXXOPTIMFLAGS=$CXXOPTIMFLAGS" >> dummy_mex.mki
echo "CXXDEBUGFLAGS=$CXXDEBUGFLAGS" >> dummy_mex.mki
echo "LD=$LD" >> dummy_mex.mki
echo "LDFLAGS=$LDFLAGS" >> dummy_mex.mki
echo "LDOPTIMFLAGS=$LDOPTIMFLAGS" >> dummy_mex.mki
echo "LDDEBUGFLAGS=$LDDEBUGFLAGS" >> dummy_mex.mki
echo "Arch=$Arch" >> dummy_mex.mki
echo OMPFLAGS= >> dummy_mex.mki
echo OMPLINKFLAGS= >> dummy_mex.mki
echo "EMC_COMPILER=gcc" >> dummy_mex.mki
echo "EMC_CONFIG=optim" >> dummy_mex.mki
"/usr/local/MATLAB/R2015a/bin/glnxa64/gmake" -B -f dummy_mex.mk
