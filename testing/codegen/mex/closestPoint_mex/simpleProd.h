/*
 * simpleProd.h
 *
 * Code generation for function 'simpleProd'
 *
 */

#ifndef __SIMPLEPROD_H__
#define __SIMPLEPROD_H__

/* Include files */
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include "mwmathutil.h"
#include "tmwtypes.h"
#include "mex.h"
#include "emlrt.h"
#include "blas.h"
#include "rtwtypes.h"
#include "closestPoint_mex_types.h"

/* Function Declarations */
extern real_T simpleProd(const emlrtStack *sp, real_T a, real_T b);

#ifdef __WATCOMC__

#pragma aux simpleProd value [8087];

#endif
#endif

/* End of code generation (simpleProd.h) */
