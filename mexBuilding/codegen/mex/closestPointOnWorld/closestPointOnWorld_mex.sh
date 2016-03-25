MATLAB="/usr/local/MATLAB/R2015a"
Arch=glnxa64
ENTRYPOINT=mexFunction
MAPFILE=$ENTRYPOINT'.map'
PREFDIR="/home/bsaund/.matlab/R2015a"
OPTSFILE_NAME="./setEnv.sh"
. $OPTSFILE_NAME
COMPILER=$CC
. $OPTSFILE_NAME
echo "# Make settings for closestPointOnWorld" > closestPointOnWorld_mex.mki
echo "CC=$CC" >> closestPointOnWorld_mex.mki
echo "CFLAGS=$CFLAGS" >> closestPointOnWorld_mex.mki
echo "CLIBS=$CLIBS" >> closestPointOnWorld_mex.mki
echo "COPTIMFLAGS=$COPTIMFLAGS" >> closestPointOnWorld_mex.mki
echo "CDEBUGFLAGS=$CDEBUGFLAGS" >> closestPointOnWorld_mex.mki
echo "CXX=$CXX" >> closestPointOnWorld_mex.mki
echo "CXXFLAGS=$CXXFLAGS" >> closestPointOnWorld_mex.mki
echo "CXXLIBS=$CXXLIBS" >> closestPointOnWorld_mex.mki
echo "CXXOPTIMFLAGS=$CXXOPTIMFLAGS" >> closestPointOnWorld_mex.mki
echo "CXXDEBUGFLAGS=$CXXDEBUGFLAGS" >> closestPointOnWorld_mex.mki
echo "LD=$LD" >> closestPointOnWorld_mex.mki
echo "LDFLAGS=$LDFLAGS" >> closestPointOnWorld_mex.mki
echo "LDOPTIMFLAGS=$LDOPTIMFLAGS" >> closestPointOnWorld_mex.mki
echo "LDDEBUGFLAGS=$LDDEBUGFLAGS" >> closestPointOnWorld_mex.mki
echo "Arch=$Arch" >> closestPointOnWorld_mex.mki
echo OMPFLAGS= >> closestPointOnWorld_mex.mki
echo OMPLINKFLAGS= >> closestPointOnWorld_mex.mki
echo "EMC_COMPILER=gcc" >> closestPointOnWorld_mex.mki
echo "EMC_CONFIG=optim" >> closestPointOnWorld_mex.mki
"/usr/local/MATLAB/R2015a/bin/glnxa64/gmake" -B -f closestPointOnWorld_mex.mk
