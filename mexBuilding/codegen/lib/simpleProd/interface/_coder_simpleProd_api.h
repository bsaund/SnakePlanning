/*
 * _coder_simpleProd_api.h
 *
 * Code generation for function '_coder_simpleProd_api'
 *
 */

#ifndef ___CODER_SIMPLEPROD_API_H__
#define ___CODER_SIMPLEPROD_API_H__

/* Include files */
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include <stddef.h>
#include <stdlib.h>
#include "_coder_simpleProd_api.h"

/* Variable Declarations */
extern emlrtCTX emlrtRootTLSGlobal;
extern emlrtContext emlrtContextGlobal;

/* Function Declarations */
extern real_T simpleProd(real_T a, real_T b);
extern void simpleProd_api(const mxArray * const prhs[2], const mxArray *plhs[1]);
extern void simpleProd_atexit(void);
extern void simpleProd_initialize(void);
extern void simpleProd_terminate(void);
extern void simpleProd_xil_terminate(void);

#endif

/* End of code generation (_coder_simpleProd_api.h) */
