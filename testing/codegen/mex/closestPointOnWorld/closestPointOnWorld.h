/*
 * closestPointOnWorld.h
 *
 * Code generation for function 'closestPointOnWorld'
 *
 */

#ifndef __CLOSESTPOINTONWORLD_H__
#define __CLOSESTPOINTONWORLD_H__

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
#include "closestPointOnWorld_types.h"

/* Function Declarations */
extern void closestPointOnWorld(const emlrtStack *sp, const real_T p_test[3],
  const struct0_T *world, real_T p[3]);

#endif

/* End of code generation (closestPointOnWorld.h) */
