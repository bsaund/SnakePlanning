/*
 * _coder_closestPointOnWorld_api.h
 *
 * Code generation for function '_coder_closestPointOnWorld_api'
 *
 */

#ifndef ___CODER_CLOSESTPOINTONWORLD_API_H__
#define ___CODER_CLOSESTPOINTONWORLD_API_H__

/* Include files */
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include <stddef.h>
#include <stdlib.h>
#include "_coder_closestPointOnWorld_api.h"

/* Type Definitions */
#ifndef struct_emxArray_real_T
#define struct_emxArray_real_T

struct emxArray_real_T
{
  real_T *data;
  int32_T *size;
  int32_T allocatedSize;
  int32_T numDimensions;
  boolean_T canFreeData;
};

#endif                                 /*struct_emxArray_real_T*/

#ifndef typedef_emxArray_real_T
#define typedef_emxArray_real_T

typedef struct emxArray_real_T emxArray_real_T;

#endif                                 /*typedef_emxArray_real_T*/

#ifndef typedef_struct0_T
#define typedef_struct0_T

typedef struct {
  emxArray_real_T *faces;
  emxArray_real_T *vertices;
} struct0_T;

#endif                                 /*typedef_struct0_T*/

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

/* Function Declarations */
extern void closestPointOnWorld(real_T p_test[3], struct0_T *world, real_T p[3]);
extern void closestPointOnWorld_api(const mxArray *prhs[2], const mxArray *plhs
  [1]);
extern void closestPointOnWorld_atexit(void);
extern void closestPointOnWorld_initialize(void);
extern void closestPointOnWorld_terminate(void);
extern void closestPointOnWorld_xil_terminate(void);

#endif

/* End of code generation (_coder_closestPointOnWorld_api.h) */
