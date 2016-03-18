/*
 * closestPoint.h
 *
 * Code generation for function 'closestPoint'
 *
 */

#ifndef __CLOSESTPOINT_H__
#define __CLOSESTPOINT_H__

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
extern void closestPoint(const real_T p_test[3], const real_T p1[3], const
  real_T p2[3], const real_T p3[3], real_T p_plane[3]);

#endif

/* End of code generation (closestPoint.h) */
